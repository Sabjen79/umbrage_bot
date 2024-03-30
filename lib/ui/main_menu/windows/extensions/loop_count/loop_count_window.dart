import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/extensions/loop_count.dart';
import 'package:umbrage_bot/ui/components/simple_switch.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';
import 'package:umbrage_bot/ui/main_menu/windows/extensions/extension_cover.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_menu_router.dart';
import 'package:umbrage_bot/ui/main_menu/windows/extensions/loop_count/loop_count_add_message.dart';
import 'package:umbrage_bot/ui/main_menu/windows/extensions/loop_count/loop_count_message.dart';
import 'package:umbrage_bot/ui/main_menu/windows/settings/settings_row.dart';

class LoopCountWindow extends MainWindow {
  const LoopCountWindow({super.key}) : super(
    route: "loop_count",
    name: "Loop Count",
    sideBarIcon: Symbols.loop
  );

  @override
  State<LoopCountWindow> createState() => _MuteKickWindowState();
}

class _MuteKickWindowState extends State<LoopCountWindow> with ExtensionCover, SettingsRow {
  final LoopCount config = Bot().loopCount;
  late bool _enable;
  late int _triggerMultiple;
  late int _triggerStart;
  late bool _messageOnEnd;

  late List<String> _messages;
  late List<String> _endMessages;

  @override
  void initState() {
    super.initState();
    reset();
  }

  void reset() {
    _enable = config.enable;
    _triggerMultiple = config.triggerMultiple;
    _triggerStart = config.triggerStart;
    _messageOnEnd = config.messageOnEnd;
    _messages = config.messages.toList();
    _endMessages = config.endMessages.toList();
  }

  void _showSaveChanges() {
    MainMenuRouter().block(() async {
      setState(() {
        reset();
      });

      MainMenuRouter().unblock();
    }, () async {
      config
        ..enable = _enable
        ..triggerMultiple = _triggerMultiple
        ..triggerStart = _triggerStart
        ..messageOnEnd = _messageOnEnd
        ..messages = _messages.toList()
        ..endMessages = _endMessages.toList();

      config.saveToJson();
      config.reset();

      MainMenuRouter().unblock();
    });
  }

  @override
  Widget build(BuildContext context) {
    return extensionCover(
      name: "Loop Count", 
      description: "If a song is looped many times, the bot will send a message regarding how much the users listened to that song.",
      switchValue: _enable,
      onSwitchChanged: (b) {
        setState(() {
          _enable = b;
        });

        _showSaveChanges();
      },
      children: () {
        var list = <Widget>[];
        
        list.addAll(
          settingsRow(
            name: "Start Count",
            first: true,
            description: "Defines the count frequency start for sending the first message.",
            child: Slider(
              divisions: 25,
              min: 1,
              max: 25,
              label: "After ${_triggerStart.toStringAsFixed(0)} plays",
              value: _triggerStart.toDouble(),
              onChanged: (v) {
                setState(() {
                  _triggerStart = v.toInt();
                });

                _showSaveChanges();
              }
            )
          )
        );

        list.addAll(
          settingsRow(
            name: "Multiple Count",
            description: "Defines the count frequency for sending messages. The value 'x' means the bot will send count messages every x loops.",
            child: Slider(
              divisions: 25,
              min: 1,
              max: 25,
              label: "${_triggerMultiple.toStringAsFixed(0)}x",
              value: _triggerMultiple.toDouble(),
              onChanged: (v) {
                setState(() {
                  _triggerMultiple = v.toInt();
                });

                _showSaveChanges();
              }
            )
          )
        );

        list.addAll(
          settingsRow(
            name: "Send Message On End",
            description: "If enabled, the bot will send a different message when the looped track is skipped or ends unlooped.",
            child: SimpleSwitch(
              size: 45,
              value: _messageOnEnd,
              onChanged: (b) {
                setState(() {
                  _messageOnEnd = b;
                });

                _showSaveChanges();
              }
            )
          )
        );

        list.addAll([
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: DiscordTheme.white2
                ),
                children: [
                  TextSpan(text: "Message Variables\n", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: DiscordTheme.white)),
                  TextSpan(text: "   \$title\$", style: TextStyle(fontWeight: FontWeight.w500)),
                  TextSpan(text: " - Track Title\n"),
                  TextSpan(text: "   \$count\$", style: TextStyle(fontWeight: FontWeight.w500)),
                  TextSpan(text: " - Loop Count\n"),
                  TextSpan(text: "   \$time\$", style: TextStyle(fontWeight: FontWeight.w500)),
                  TextSpan(text: " - Time listened"),
                ]
              )
            )
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
            width: double.infinity, 
            height: 1, 
            color: DiscordTheme.gray
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 10),
            child: Text(
              "Messages",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: DiscordTheme.white
              ),
            ),
          ),
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
                  final l = <Widget>[];

                  for(int i = 0; i < _messages.length; i++) {
                    l.add(LoopCountMessage(
                      initialValue: _messages[i],
                      onChanged: (e) {
                        _messages[i] = e;

                        _showSaveChanges();
                      },
                      onDelete: () {
                        setState(() {
                          _messages.removeAt(i);
                        });

                        _showSaveChanges();
                      }
                    ));

                    l.add(Container(color: DiscordTheme.gray, width: double.infinity, height: 1));
                  }

                  return l;
                }(),
                
                LoopCountAddMessage(
                  onTap: () {
                    setState(() {
                      _messages.add("");
                    });

                    _showSaveChanges();
                  },
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
            width: double.infinity, 
            height: 1, 
            color: DiscordTheme.gray
          ),
        ]);

        if(_messageOnEnd) {
          list.addAll([
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 10),
              child: Text(
                "End Messages",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: DiscordTheme.white
                ),
              ),
            ),
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
                    final l = <Widget>[];

                    for(int i = 0; i < _endMessages.length; i++) {
                      l.add(LoopCountMessage(
                        initialValue: _endMessages[i],
                        onChanged: (e) {
                          _endMessages[i] = e;

                          _showSaveChanges();
                        },
                        onDelete: () {
                          setState(() {
                            _endMessages.removeAt(i);
                          });

                          _showSaveChanges();
                        }
                      ));

                      l.add(Container(color: DiscordTheme.gray, width: double.infinity, height: 1));
                    }

                    return l;
                  }(),
                  
                  LoopCountAddMessage(
                    onTap: () {
                      setState(() {
                        _endMessages.add("");
                      });

                      _showSaveChanges();
                    },
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
              width: double.infinity, 
              height: 1, 
              color: DiscordTheme.gray
            ),
          ]);
        }
        
        return list;
      }()
    );
  }
}