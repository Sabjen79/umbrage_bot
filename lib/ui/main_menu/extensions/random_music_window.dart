import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/configuration/bot_configuration.dart';
import 'package:umbrage_bot/ui/components/simple_chance_field.dart';
import 'package:umbrage_bot/ui/main_menu/extensions/extension_cover.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_menu_router.dart';
import 'package:umbrage_bot/ui/main_menu/settings/settings_row.dart';

class RandomMusicWindow extends MainWindow {
  const RandomMusicWindow({super.key}) : super(
    route: "random_music",
    name: "Random Music",
    sideBarIcon: Symbols.shuffle
  );

  @override
  State<RandomMusicWindow> createState() => _RandomMusicWindowState();
}

class _RandomMusicWindowState extends State<RandomMusicWindow> with ExtensionCover, SettingsRow {
  final BotConfiguration config = Bot().config;
  late bool _randomMusicEnable;
  late int _randomMusicMinCooldown;
  late int _randomMusicMaxCooldown;
  late double _randomMusicSkipChance;

  @override
  void initState() {
    super.initState();
    reset();
  }

  void reset() {
    _randomMusicEnable = config.randomMusicEnable;
    _randomMusicMinCooldown = config.randomMusicMinCooldown;
    _randomMusicMaxCooldown = config.randomMusicMaxCooldown;
    _randomMusicSkipChance = config.randomMusicSkipChance;
  }

  void _showSaveChanges() {
    MainMenuRouter().block(() async {
      setState(() {
        reset();
      });

      MainMenuRouter().unblock();
    }, () async {
      config
        ..randomMusicEnable = _randomMusicEnable
        ..randomMusicMinCooldown = _randomMusicMinCooldown
        ..randomMusicMaxCooldown = _randomMusicMaxCooldown
        ..randomMusicSkipChance = _randomMusicSkipChance;

      config.saveToJson();

      MainMenuRouter().unblock();
    });
  }

  @override
  Widget build(BuildContext context) {
    return extensionCover(
      name: "Random Music", 
      description: "The bot will periodically queue music by his own, based on what was previously queued by other users.\nSongs will be memorized even if this extension is disabled.",
      switchValue: _randomMusicEnable,
      onSwitchChanged: (b) {
        setState(() {
          _randomMusicEnable = b;
        });

        _showSaveChanges();
      },
      children: () {
        var list = <Widget>[];

        list.addAll(
          settingsRow(
            first: true,
            name: "Random Music Cooldown",
            description: "The time period that the bot will wait before queueing another song.",
            child: RangeSlider(
              divisions: 55,
              min: 300000,
              max: 3600000,
              labels: RangeLabels(
                "${(_randomMusicMinCooldown/60000).toStringAsFixed(0)} minutes", 
                "${(_randomMusicMaxCooldown/60000).toStringAsFixed(0)} minutes"
              ),
              values: RangeValues(_randomMusicMinCooldown.toDouble(), _randomMusicMaxCooldown.toDouble()),
              onChanged: (v) {
                setState(() {
                  _randomMusicMinCooldown = v.start.toInt();
                  _randomMusicMaxCooldown = v.end.toInt();
                });

                _showSaveChanges();
              }
            )
          )
        );

        list.addAll(
          settingsRow(
            name: "Random Music Skip Chance",
            description: "If there is a song queued by an user and the bot queues a song by his own, there is a chance that the bot will skip the user's song to listen to his own quicker. Leave at 0% to disable.",
            child: SimpleChanceField(
              chance: _randomMusicSkipChance,
              onChanged: (v) {
                setState(() {
                  _randomMusicSkipChance = v;
                });

                _showSaveChanges();
              }
            )
          )
        );
          
        return list;
      }()
    );
  }
}