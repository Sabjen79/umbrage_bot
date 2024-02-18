import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/configuration/bot_configuration.dart';
import 'package:umbrage_bot/ui/components/simple_switch.dart';
import 'package:umbrage_bot/ui/main_menu/extensions/extension_cover.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_menu_router.dart';
import 'package:umbrage_bot/ui/main_menu/settings/settings_row.dart';

class MuteKickWindow extends MainWindow {
  const MuteKickWindow({super.key}) : super(
    route: "mute_kick",
    name: "Mute-Nuke",
    sideBarIcon: Symbols.bomb
  );

  @override
  State<MuteKickWindow> createState() => _MuteKickWindowState();
}

class _MuteKickWindowState extends State<MuteKickWindow> with ExtensionCover, SettingsRow {
  final BotConfiguration config = Bot().config;
  late bool _muteKickEnable;
  late bool _muteKickOnlyMute;
  late bool _muteKickIgnoreAfk;
  late int _muteKickDuration;

  @override
  void initState() {
    super.initState();
    reset();
  }

  void reset() {
    _muteKickEnable = config.muteKickEnable;
    _muteKickOnlyMute = config.muteKickOnlyMute;
    _muteKickIgnoreAfk = config.muteKickIgnoreAfk;
    _muteKickDuration = config.muteKickDuration;
  }

  void _showSaveChanges() {
    MainMenuRouter().block(() async {
      setState(() {
        reset();
      });

      MainMenuRouter().unblock();
    }, () async {
      config
        ..muteKickEnable = _muteKickEnable
        ..muteKickOnlyMute = _muteKickOnlyMute
        ..muteKickIgnoreAfk = _muteKickIgnoreAfk
        ..muteKickDuration = _muteKickDuration;

      config.saveToJson();

      MainMenuRouter().unblock();
    });
  }

  @override
  Widget build(BuildContext context) {
    return extensionCover(
      name: "Mute-Nuke", 
      description: "If an user stays muted/deafened for too long on a voice channel, the bot will disconnect him.",
      switchValue: _muteKickEnable,
      onSwitchChanged: (b) {
        setState(() {
          _muteKickEnable = b;
        });

        _showSaveChanges();
      },
      children: () {
        var list = <Widget>[];
        
        list.addAll(
          settingsRow(
            first: true,
            name: "Kick Strictly Muted Users",
            description: "If enabled, the bot will only kick users that are muted, but not deafened.",
            child: SimpleSwitch(
              size: 45,
              value: _muteKickOnlyMute,
              onChanged: (b) {
                setState(() {
                  _muteKickOnlyMute = b;
                });

                _showSaveChanges();
              }
            )
          )
        );

        list.addAll(
          settingsRow(
            name: "Ignore Afk Users",
            description: "If enabled, the bot will not kick users connected in the afk voice channel.",
            child: SimpleSwitch(
              size: 45,
              value: _muteKickIgnoreAfk,
              onChanged: (b) {
                setState(() {
                  _muteKickIgnoreAfk = b;
                });

                _showSaveChanges();
              }
            )
          )
        );

        list.addAll(
          settingsRow(
            name: "Mute Duration",
            description: "The time period that a user needs to be muted for him to be kicked.",
            child: Slider(
              divisions: 59,
              min: 60000,
              max: 3600000,
              label: "${(_muteKickDuration/60000).toStringAsFixed(0)} minutes",
              value: _muteKickDuration.toDouble(),
              onChanged: (v) {
                setState(() {
                  _muteKickDuration = v.toInt();
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