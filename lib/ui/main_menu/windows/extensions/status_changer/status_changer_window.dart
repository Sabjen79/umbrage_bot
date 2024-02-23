import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/extensions/status_changer_manager.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';
import 'package:umbrage_bot/ui/main_menu/windows/extensions/extension_cooldown_widget.dart';
import 'package:umbrage_bot/ui/main_menu/windows/extensions/extension_cover.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_menu_router.dart';
import 'package:umbrage_bot/ui/main_menu/windows/extensions/status_changer/status_changer_add_entry.dart';
import 'package:umbrage_bot/ui/main_menu/windows/extensions/status_changer/status_changer_entry.dart';
import 'package:umbrage_bot/ui/main_menu/windows/settings/settings_row.dart';

class StatusChangerWindow extends MainWindow {
  const StatusChangerWindow({super.key}) : super(
    route: "status_changer",
    name: "Status Changer",
    sideBarIcon: Symbols.notes
  );

  @override
  State<StatusChangerWindow> createState() => _StatusChangerWindowState();
}

class _StatusChangerWindowState extends State<StatusChangerWindow> with ExtensionCover, SettingsRow {
  final StatusChangerManager manager = Bot().statusChangerManager;

  late List<String> _statusList;
  late bool _enable;
  late int _minCooldown;
  late int _maxCooldown;

  late ExtensionCooldownWidget _cooldownWidget;

  @override
  void initState() {
    super.initState();
    _cooldownWidget = ExtensionCooldownWidget(
      timer: manager.timer,
    );
    reset();
  }

  void reset() {
    _enable = manager.enable;
    _statusList = manager.statusList.toList();
    _minCooldown = manager.minCooldown;
    _maxCooldown = manager.maxCooldown;
  }

  void _showSaveChanges() {
    MainMenuRouter().block(() async {
      setState(() {
        reset();
      });

      MainMenuRouter().unblock();
    }, () async {

      manager
        ..enable = _enable
        ..statusList = _statusList
        ..minCooldown = _minCooldown
        ..maxCooldown = _maxCooldown;

      if(!_enable) manager.clearStatus(); 

      manager.saveToJson();

      MainMenuRouter().unblock();
    });
  }

  @override
  Widget build(BuildContext context) {
    return extensionCover(
      name: "Status Changer", 
      description: "The bot will periodically change his status. Disable the feature to have no status.", 
      switchValue: _enable,
      onSwitchChanged: (b) {
        setState(() {
          _enable = b;
        });

        _showSaveChanges();
      },
      cooldownWidget: _cooldownWidget,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              width: double.infinity,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: DiscordTheme.backgroundColorDarkest,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...() {
                    final list = <Widget>[];

                    for(int i = 0; i < _statusList.length; i++) {
                      list.add(StatusChangerEntry(
                        initialValue: _statusList[i],
                        onChanged: (e) {
                          _statusList[i] = e;

                          _showSaveChanges();
                        },
                        onDelete: () {
                          setState(() {
                            _statusList.removeAt(i);
                          });

                          _showSaveChanges();
                        }
                      ));

                      list.add(Container(color: DiscordTheme.gray, width: double.infinity, height: 1));
                    }

                    return list;
                  }(),
                  
                  StatusChangerAddEntry(
                    onTap: () {
                      setState(() {
                        _statusList.add("0");
                      });

                      _showSaveChanges();
                    },
                  )
                ],
              ),
            ),

            ...settingsRow(
              first: true,
              name: "Cooldown",
              description: "The time period that the bot will wait before changing his status again",
              child: RangeSlider(
                divisions: 23,
                min: 300000,
                max: 7200000,
                labels: RangeLabels(
                  "${(_minCooldown/60000).toStringAsFixed(0)} minutes", 
                  "${(_maxCooldown/60000).toStringAsFixed(0)} minutes"
                ),
                values: RangeValues(_minCooldown.toDouble(), _maxCooldown.toDouble()),
                onChanged: (v) {
                  setState(() {
                    _minCooldown = v.start.toInt();
                    _maxCooldown = v.end.toInt();
                  });

                  _showSaveChanges();
                }
              )
            ),
          ],
        )
      ]
    );
  }
}