import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/configuration/bot_configuration.dart';
import 'package:umbrage_bot/ui/components/simple_switch.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_menu_router.dart';
import 'package:umbrage_bot/ui/main_menu/settings/settings_row.dart';

class MusicSettingsWindow extends MainWindow {
  const MusicSettingsWindow({super.key}) : super(
    route: "music",
    name: "Music & Voice",
    sideBarIcon: Symbols.music_note
  );


  @override
  State<MusicSettingsWindow> createState() => _MusicSettingsWindowState();
}

class _MusicSettingsWindowState extends State<MusicSettingsWindow> with SettingsRow {
  final BotConfiguration config = Bot().config;
  late bool _restrictMusicChannel;
  late TextEditingController _restrictMusicChannelTextController;
  late bool _autoConnectVoice;
  late bool _autoConnectVoicePersist;
  late TextEditingController _invalidMusicCommandChannelMessageController;

  @override
  void initState() {
    super.initState();
    reset();
  }

  void reset() {
    _restrictMusicChannel = config.restrictMusicChannel;
    _restrictMusicChannelTextController = TextEditingController(text: config.restrictMusicChannelMessage);
    _autoConnectVoice = config.autoConnectVoice;
    _autoConnectVoicePersist = config.autoConnectVoicePersist;
    _invalidMusicCommandChannelMessageController = TextEditingController(text: config.invalidMusicCommandChannelMessage);
  }

  void _showSaveChanges() {
    MainMenuRouter().block(() async {
      setState(() {
        reset();
      });

      MainMenuRouter().unblock();
    }, () async {
      config.restrictMusicChannel = _restrictMusicChannel;
      config.restrictMusicChannelMessage = _restrictMusicChannelTextController.text;
      config.autoConnectVoice = _autoConnectVoice;
      config.autoConnectVoicePersist = _autoConnectVoicePersist;
      config.invalidMusicCommandChannelMessage = _invalidMusicCommandChannelMessageController.text;

      config.saveToJson();

      MainMenuRouter().unblock();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      children: () {
        var list = <Widget>[];

        list.add(titleRow("MUSIC", false));

        list.addAll(
          settingsRow(
            first: true,
            name: "Restrict Music Channel",
            description: "If enabled, users can't write messages in the music channel, they can only queue music commands",
            child: SimpleSwitch(
              size: 45,
              value: _restrictMusicChannel,
              onChanged: (b) {
                setState(() {
                  _restrictMusicChannel = b;
                });

                _showSaveChanges();
              }
            )
          )
        );

        if(_restrictMusicChannel) {
          list.addAll(
            settingsRow(
              name: "Restrict Music Channel Message",
              description: "The message that the bot will send when a user tries to write in a music channel",
              child: TextField(
                controller: _restrictMusicChannelTextController,
                onChanged: (v) {
                  _showSaveChanges();
                },
              )
            )
          );
        }

        list.addAll(
          settingsRow(
            name: "Invalid Music Command Channel Message",
            description: "The message that the bot will send when a user tries to queue a music command in a non-music channel.\nThe string '\$channel\$' is replaced by the mention of the music channel.",
            child: TextField(
              controller: _invalidMusicCommandChannelMessageController,
              onChanged: (v) {
                _showSaveChanges();
              },
            )
          )
        );

        list.add(titleRow("AUTO-CONNECT"));

        list.addAll(
          settingsRow(
            first: true,
            name: "Auto Connect to Voice Channels",
            description: "If enabled, the bot will automatically join or leave voice channels as he pleases.",
            child: SimpleSwitch(
              size: 45,
              value: _autoConnectVoice,
              onChanged: (b) {
                setState(() {
                  _autoConnectVoice = b;
                });

                _showSaveChanges();
              }
            )
          )
        );

        if(_autoConnectVoice) {
          list.addAll(
            settingsRow(
              name: "Solitude in Voice Channels",
              description: "If enabled, the bot will not leave voice channels when left alone and will mute himself to not talk by his own.",
              child: SimpleSwitch(
                size: 45,
                value: _autoConnectVoicePersist,
                onChanged: (b) {
                  setState(() {
                    _autoConnectVoicePersist = b;
                  });

                  _showSaveChanges();
                }
              )
            )
          );
        }

        return list;
      }(),
    );
  }
}