import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/configuration/bot_configuration.dart';
import 'package:umbrage_bot/ui/components/simple_discord_dialog.dart';
import 'package:umbrage_bot/ui/main_menu/extensions/extension_cover.dart';
import 'package:umbrage_bot/ui/main_menu/extensions/profile_picture/profile_picture_cooldown.dart';
import 'package:umbrage_bot/ui/main_menu/extensions/profile_picture/profile_picture_image.dart';
import 'package:umbrage_bot/ui/main_menu/main_menu.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_menu_router.dart';
import 'package:umbrage_bot/ui/main_menu/settings/settings_row.dart';
import 'package:window_manager/window_manager.dart';

class ProfilePictureWindow extends MainWindow {
  const ProfilePictureWindow({super.key}) : super(
    route: "profile_picture",
    name: "Profile Picture",
    sideBarIcon: Symbols.account_circle
  );

  @override
  State<ProfilePictureWindow> createState() => _ProfilePictureWindowState();
}

class _ProfilePictureWindowState extends State<ProfilePictureWindow> with ExtensionCover, SettingsRow {
  final BotConfiguration config = Bot().config;
  final List<File> _images = [];

  late bool _profilePictureEnable;
  late int _profilePictureMinCooldown;
  late int _profilePictureMaxCooldown;

  @override
  void initState() {
    super.initState();
    reset();
  }

  void reset() {
    _images.clear();
    _images.addAll(Bot().profilePictureManager.pictures);

    _profilePictureEnable = config.profilePictureEnable;
    _profilePictureMinCooldown = config.profilePictureMinCooldown;
    _profilePictureMaxCooldown = config.profilePictureMaxCooldown;
  }

  void _showSaveChanges() {
    MainMenuRouter().block(() async {
      setState(() {
        reset();
      });

      MainMenuRouter().unblock();
    }, () async {

      Bot().profilePictureManager.setImages(_images);

      config
        ..profilePictureEnable = _profilePictureEnable
        ..profilePictureMinCooldown = _profilePictureMinCooldown
        ..profilePictureMaxCooldown = _profilePictureMaxCooldown;

      config.saveToJson();

      MainMenuRouter().unblock();
    });
  }

  void _showFileTooBigDialog() {
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
            "Images cannot be larger than 5MB.",
            textAlign: TextAlign.center,
          )
        ),
      )
    );
  }

  Future<void> _addPictures() async {
    windowManager.setIgnoreMouseEvents(true);

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowedExtensions: ['jpeg', 'jpg', 'png'],
      allowMultiple: true
    );

    windowManager.setIgnoreMouseEvents(false);

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();

      for(final file in files) {
        if(file.lengthSync() > 5000000) {
          _showFileTooBigDialog();
          return;
        }
      }

      _images.addAll(files);
      
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
      name: "Profile Picture", 
      description: "The bot will periodically change his profile picture", 
      switchValue: _profilePictureEnable,
      onSwitchChanged: (b) {
        setState(() {
          _profilePictureEnable = b;
        });

        _showSaveChanges();
      },
      children: [
        Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: ProfilePictureCooldown(),
            ),
            
            SizedBox(
              width: MainMenu.getMainWindowWidth(context),
              child: Wrap(
                alignment: WrapAlignment.start,
                
                children: () {
                  final list = <Widget>[];

                  for(final image in _images) {
                    list.add(
                      ProfilePictureImage(
                        image: image,
                        onDelete: (file) {
                          setState(() {
                            _images.remove(file);
                          });

                          _showSaveChanges();
                        },
                      )
                    );
                  }

                  list.add(ProfilePictureImage(
                    image: null,
                    onTap: _addPictures,
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
                  name: "Profile Picture Cooldown",
                  description: "The time period that the bot will wait before changing his profile picture.",
                  child: RangeSlider(
                    divisions: 22,
                    min: 600000,
                    max: 7200000,
                    labels: RangeLabels(
                      "${(_profilePictureMinCooldown/60000).toStringAsFixed(0)} minutes", 
                      "${(_profilePictureMaxCooldown/60000).toStringAsFixed(0)} minutes"
                    ),
                    values: RangeValues(_profilePictureMinCooldown.toDouble(), _profilePictureMaxCooldown.toDouble()),
                    onChanged: (v) {
                      setState(() {
                        _profilePictureMinCooldown = v.start.toInt();
                        _profilePictureMaxCooldown = v.end.toInt();
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