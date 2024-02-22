import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/configuration/bot_configuration.dart';
import 'package:umbrage_bot/ui/main_menu/windows/extensions/extension_cover.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_menu_router.dart';
import 'package:umbrage_bot/ui/main_menu/windows/settings/settings_row.dart';

class VolumeBoosterWindow extends MainWindow {
  const VolumeBoosterWindow({super.key}) : super(
    route: "volume_booster",
    name: "Volume Booster",
    sideBarIcon: Symbols.volume_up
  );

  @override
  State<VolumeBoosterWindow> createState() => _VolumeBoosterWindowState();
}

class _VolumeBoosterWindowState extends State<VolumeBoosterWindow> with ExtensionCover, SettingsRow {
  final BotConfiguration config = Bot().config;
  late bool _volumeBoostEnable;
  late int _volumeBoostMinCooldown;
  late int _volumeBoostMaxCooldown;
  late int _volumeBoostAmplitude;

  @override
  void initState() {
    super.initState();
    reset();
  }

  void reset() {
    _volumeBoostEnable = config.volumeBoostEnable;
    _volumeBoostMinCooldown = config.volumeBoostMinCooldown;
    _volumeBoostMaxCooldown = config.volumeBoostMaxCooldown;
    _volumeBoostAmplitude = config.volumeBoostAmplitude;
  }

  void _showSaveChanges() {
    MainMenuRouter().block(() async {
      setState(() {
        reset();
      });

      MainMenuRouter().unblock();
    }, () async {
      config
        ..volumeBoostEnable = _volumeBoostEnable
        ..volumeBoostMinCooldown = _volumeBoostMinCooldown
        ..volumeBoostMaxCooldown = _volumeBoostMaxCooldown
        ..volumeBoostAmplitude = _volumeBoostAmplitude;

      config.saveToJson();

      MainMenuRouter().unblock();
    });
  }

  @override
  Widget build(BuildContext context) {
    return extensionCover(
      name: "Volume Booster", 
      description: "The bot will boost his volume for a short while, to annoy everyone listening to him",
      switchValue: _volumeBoostEnable,
      onSwitchChanged: (b) {
        setState(() {
          _volumeBoostEnable = b;
        });

        _showSaveChanges();
      },
      children: () {
        var list = <Widget>[];

        list.addAll(
          settingsRow(
            first: true,
            name: "Volume Boost Cooldown",
            description: "The time period that the bot will wait before boosting the volume again.",
            child: RangeSlider(
              divisions: 30,
              min: 1800000,
              max: 10800000,
              labels: RangeLabels(
                "${(_volumeBoostMinCooldown/60000).toStringAsFixed(0)} minutes", 
                "${(_volumeBoostMaxCooldown/60000).toStringAsFixed(0)} minutes"
              ),
              values: RangeValues(_volumeBoostMinCooldown.toDouble(), _volumeBoostMaxCooldown.toDouble()),
              onChanged: (v) {
                setState(() {
                  _volumeBoostMinCooldown = v.start.toInt();
                  _volumeBoostMaxCooldown = v.end.toInt();
                });

                _showSaveChanges();
              }
            )
          )
        );

        list.addAll(
          settingsRow(
            name: "Volume Boost Amplitude",
            description: "The volume amplitude of the boost. 100% is normal volume.",
            child: Slider(
              divisions: 16,
              min: 100,
              max: 500,
              label: "${_volumeBoostAmplitude.toString()}%",
              value: _volumeBoostAmplitude.toDouble(),
              onChanged: (v) {
                setState(() {
                  _volumeBoostAmplitude = v.toInt();
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