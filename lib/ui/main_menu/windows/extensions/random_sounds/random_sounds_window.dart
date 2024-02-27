import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/configuration/bot_configuration.dart';
import 'package:umbrage_bot/bot/extensions/random_sounds_manager.dart';
import 'package:umbrage_bot/ui/components/simple_chance_field.dart';
import 'package:umbrage_bot/ui/components/simple_discord_dialog.dart';
import 'package:umbrage_bot/ui/components/simple_switch.dart';
import 'package:umbrage_bot/ui/main_menu/windows/extensions/extension_cover.dart';
import 'package:umbrage_bot/ui/main_menu/main_menu.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_menu_router.dart';
import 'package:umbrage_bot/ui/main_menu/windows/extensions/random_sounds/random_sounds_item.dart';
import 'package:umbrage_bot/ui/main_menu/windows/settings/settings_row.dart';
import 'package:window_manager/window_manager.dart';

class RandomSoundsWindow extends MainWindow {
  const RandomSoundsWindow({super.key}) : super(
    route: "random_sounds",
    name: "Random Sounds",
    sideBarIcon: Symbols.mic
  );

  @override
  State<RandomSoundsWindow> createState() => _RandomSoundsWindowState();
}

class _RandomSoundsWindowState extends State<RandomSoundsWindow> with ExtensionCover, SettingsRow {
  final BotConfiguration config = Bot().config;
  List<File> _sounds = [];

  late bool _randomSoundsEnable;
  late bool _randomSoundsPlayOnJoin;
  late int _randomSoundsMinCooldown;
  late int _randomSoundsMaxCooldown;
  late double _randomSoundsLoopChance;

  @override
  void initState() {
    super.initState();

    reset();
  }

  void reset() {
    _sounds = RandomSoundsManager.sounds.toList();

    _randomSoundsEnable = config.randomSoundsEnable;
    _randomSoundsPlayOnJoin = config.randomSoundsPlayOnJoin;
    _randomSoundsMinCooldown = config.randomSoundsMinCooldown;
    _randomSoundsMaxCooldown = config.randomSoundsMaxCooldown;
    _randomSoundsLoopChance = config.randomSoundsLoopChance;
  }

  void _showSaveChanges() {
    MainMenuRouter().block(() async {
      setState(() {
        reset();
      });

      MainMenuRouter().unblock();
    }, () async {

      RandomSoundsManager.setSounds(_sounds);

      config
        ..randomSoundsEnable = _randomSoundsEnable
        ..randomSoundsPlayOnJoin = _randomSoundsPlayOnJoin
        ..randomSoundsMinCooldown = _randomSoundsMinCooldown
        ..randomSoundsMaxCooldown = _randomSoundsMaxCooldown
        ..randomSoundsLoopChance = _randomSoundsLoopChance;

      config.saveToJson();

      setState(() {
        reset();
      });

      MainMenuRouter().unblock();
    });
  }

  void _showSoundTooLongDialog() {
    showDialog(
      context: context, 
      builder: (context) => SimpleDiscordDialog(
        cancelText: "",
        submitText: "OKAY, SORRY!",
        onSubmit: () async => {
          Navigator.pop(context, false)
        },
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          width: 300,
          child: const Text(
            "Sounds cannot be larger than 5MB.",
            textAlign: TextAlign.center,
          )
        ),
      )
    );
  }

  Future<void> _addSounds() async {
    windowManager.setIgnoreMouseEvents(true);

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowedExtensions: ['mp3', 'wav'],
      allowMultiple: true
    );

    windowManager.setIgnoreMouseEvents(false);

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();

      for(final file in files) {
        if(file.lengthSync() > 5000000) {
          _showSoundTooLongDialog();
          return;
        }
      }

      _sounds.addAll(files);
      
      setState(() {
        _showSaveChanges();
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return extensionCover(
      name: "Random Sounds", 
      description: "The bot will periodically queue custom sounds to the music queue.", 
      switchValue: _randomSoundsEnable,
      onSwitchChanged: (b) {
        setState(() {
          _randomSoundsEnable = b;
        });

        _showSaveChanges();
      },
      children: [
        Column(
          children: [
            
            SizedBox(
              width: MainMenu.getMainWindowWidth(context),
              child: Wrap(
                alignment: WrapAlignment.start,
                
                children: () {
                  final list = <Widget>[];

                  for(final sound in _sounds) {
                    list.add(
                      RandomSoundsItem(
                        sound: sound,
                        onDelete: (file) {
                          setState(() {
                            _sounds.remove(file);
                          });

                          _showSaveChanges();
                        },
                      )
                    );
                  }

                  list.add(RandomSoundsItem(
                    sound: null,
                    onTap: _addSounds,
                  ));

                  return list;
                }(),
              ),
            ),
            
            ...() {
              var list = <Widget>[];

              list.addAll(
                settingsRow(
                  first: true,
                  name: "Play on Join",
                  description: "If enabled, the bot will queue a random sound everytime he enters a voice channel",
                  child: SimpleSwitch(
                    size: 45,
                    value: _randomSoundsPlayOnJoin,
                    onChanged: (b) {
                      setState(() {
                        _randomSoundsPlayOnJoin = b;
                      });

                      _showSaveChanges();
                    }
                  )
                )
              );

              list.addAll(
                settingsRow(
                  name: "Random Sounds Cooldown",
                  description: "The time period that the bot will wait before queueing another sound.",
                  child: RangeSlider(
                    divisions: 55,
                    min: 300000,
                    max: 3600000,
                    labels: RangeLabels(
                      "${(_randomSoundsMinCooldown/60000).toStringAsFixed(0)} minutes", 
                      "${(_randomSoundsMaxCooldown/60000).toStringAsFixed(0)} minutes"
                    ),
                    values: RangeValues(_randomSoundsMinCooldown.toDouble(), _randomSoundsMaxCooldown.toDouble()),
                    onChanged: (v) {
                      setState(() {
                        _randomSoundsMinCooldown = v.start.toInt();
                        _randomSoundsMaxCooldown = v.end.toInt();
                      });

                      _showSaveChanges();
                    }
                  )
                )
              );

              list.addAll(
                settingsRow(
                  name: "Random Sounds Loop Chance",
                  description: "If the bot queues a sound, there is a chance that he will also toggle loop on.",
                  child: SimpleChanceField(
                    chance: _randomSoundsLoopChance,
                    onChanged: (v) {
                      setState(() {
                        _randomSoundsLoopChance = v;
                      });

                      _showSaveChanges();
                    }
                  )
                )
              );

              return list;
            }()
          ],
        )
      ]
    );
  }
}