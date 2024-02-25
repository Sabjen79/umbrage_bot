import 'dart:async';

import 'package:flutter/material.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/lexicon/conversation/conversation_message.dart';
import 'package:umbrage_bot/bot/lexicon/events/lexicon_event.dart';
import 'package:umbrage_bot/bot/lexicon/events/lexicon_private_event.dart';
import 'package:umbrage_bot/bot/lexicon/variables/lexicon_variable.dart';
import 'package:umbrage_bot/ui/components/simple_chance_field.dart';
import 'package:umbrage_bot/ui/components/simple_discord_dialog.dart';
import 'package:umbrage_bot/ui/components/simple_switch.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';
import 'package:umbrage_bot/ui/main_menu/windows/lexicon/events/lexicon_event_add_conversation_widget.dart';
import 'package:umbrage_bot/ui/main_menu/windows/lexicon/events/lexicon_event_add_message_widget.dart';
import 'package:umbrage_bot/ui/main_menu/windows/lexicon/events/lexicon_event_cooldown_button.dart';
import 'package:umbrage_bot/ui/main_menu/windows/lexicon/events/lexicon_event_message_field.dart';
import 'package:umbrage_bot/ui/main_menu/windows/lexicon/events/lexicon_event_status.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_menu_router.dart';
import 'package:umbrage_bot/ui/main_menu/secondary_side_bar/secondary_side_bar.dart';
import 'package:umbrage_bot/ui/main_menu/windows/lexicon/events/lexicon_event_variable_pill.dart';
import 'package:umbrage_bot/ui/main_menu/windows/settings/settings_row.dart';

class LexiconEventWindow extends MainWindow {
  final LexiconEvent event;

  LexiconEventWindow(this.event, {super.key}) : super(
    name: event.name,
    route: event.filename,
    sideBarIcon: event.sidebarIcon,
    category: "EVENTS",
  );

  @override
  State<LexiconEventWindow> createState() => _LexiconEventWindowState();
}

class _LexiconEventWindowState extends State<LexiconEventWindow> with TickerProviderStateMixin, SettingsRow {
  late bool _enabled;
  late double _chance;
  late int _cooldown;
  late List<List<ConversationMessage>> _messagesLists;

  late List<LexiconVariable> _variables;
  late List<LexiconEventCooldownButton> _cooldownButtons;
  StreamSubscription? _subscription;

  void init() {
    _variables = [...widget.event.variables, ...Bot().lexicon.customVariables];
    _enabled = widget.event.enabled;
    _chance = widget.event.chance;
    _cooldown = widget.event.cooldown;
    _messagesLists = widget.event.messagesLists.map((e) => e.toList()).toList();
    _resetCooldownButtons();
    _subscription?.cancel();
    _subscription = widget.event.onCooldownsChanged.listen((_) {
      _resetCooldownButtons();
      if(mounted) setState(() {});
    });
  }

  void _resetCooldownButtons() {
    _cooldownButtons = widget.event.cooldowns.keys
    .map((e) => LexiconEventCooldownButton(
      event: widget.event,
      id: e
    )).toList();
  }

  @override
  void initState() {
    super.initState();
    
    init();
  }

  @override
  void didUpdateWidget(covariant LexiconEventWindow oldWidget) {
    super.didUpdateWidget(oldWidget);

    init();
  }

  void _showSaveChanges() {
    MainMenuRouter().block(() async {
      init();

      setState(() {});

      MainMenuRouter().unblock();
    }, () async {
      var result = Bot().lexicon.updateLexiconEvent(widget.event.filename, _enabled, _chance, _cooldown, _messagesLists);

      if(!result.isSuccess) {
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
              child: Text(
                "Could not update event:\n${result.error}",
                textAlign: TextAlign.center,
              )
            ),
          )
        );
        return;
      }

      setState(() {});

      MainMenuRouter().unblock();
    });
  }

  List<Widget> _getVariableList() {
    var list = <Widget>[];

    for(var v in widget.event.variables) {
      list.add(LexiconEventVariablePill(
        keyword: "\$${v.keyword}\$",
        name: v.name,
        description: v.description,
        color: v.color
      ));
    }

    for(var v in Bot().lexicon.customVariables) {
      list.add(LexiconEventVariablePill(
        keyword: "\$${v.keyword}\$",
        name: v.name,
        description: v.description,
        color: v.color
      ));
    }

    return list;
  }

  List<Widget> _messagesFields() {
    var list = <Widget>[];

    for(int i = 0; i < _messagesLists.length; i++) {

      for(int j = 0; j < _messagesLists[i].length; j++) {
        list.add(
          LexiconEventMessageField(
            message: _messagesLists[i][j],
            variables: _variables,
            onChanged: (type, text) {
              if(type == _messagesLists[i][j].type && text == _messagesLists[i][j].message) return;

              _messagesLists[i][j].type = type;
              _messagesLists[i][j].message = text;

              _showSaveChanges();
            },
            onDelete: () {
              setState(() {
                _messagesLists[i].removeAt(j);
                if(_messagesLists[i].isEmpty) _messagesLists.removeAt(i);
              });

              _showSaveChanges();
            },
          )
        );
      }

      list.add(
        LexiconEventAddMessageWidget(
          onTap: () {
            setState(() {
              _messagesLists[i].add(ConversationMessage(0, ""));
            });

            _showSaveChanges();
          },
          onDelete: () {
            setState(() {
              _messagesLists.removeAt(i);
            });

            _showSaveChanges();
          },
        )
      );

      list.add(Container(color: DiscordTheme.gray, width: double.infinity, height: 1));
    }

    list.add(
      LexiconEventAddConversationWidget(
        onTap: () {
          setState(() {
            _messagesLists.add([ConversationMessage(0, "")]);
          });

          _showSaveChanges();
        },
      )
    );

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Stack(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                height: 120,
                decoration: const BoxDecoration(
                  color: DiscordTheme.gray,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x77000000),
                      blurRadius: 10,
                      spreadRadius: 2
                    )
                  ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: LexiconEventStatus(event: widget.event),
                    ),
                    
                    // Event Name
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        widget.event.name,
                        style: const TextStyle(
                          shadows: [
                            Shadow(
                              color: Color(0xCC000000),
                              blurRadius: 3,
                              offset: Offset(0, 1)
                            )
                          ],
                          color: DiscordTheme.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),

                    // Event Description
                    Padding(
                      padding: const EdgeInsets.only(top: 2, left: 25),
                      child: Text(
                        widget.event.description,
                        style: const TextStyle(
                          color: DiscordTheme.lightGray,
                          fontSize: 14,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 120),
                child: ListView(
                  children: [
                    ...settingsRow(
                      name: "Enabled",
                      description: "Enables/Disables this event from running.",
                      child: SimpleSwitch(
                        size: 45,
                        value: _enabled,
                        onChanged: (b) {
                          setState(() {
                            _enabled = b;
                          });
                          _showSaveChanges();
                        }
                      )
                    ),

                    ...(!_enabled ? [] : [
                      ...settingsRow(
                        name: "Chance",
                        description: "The chance that the bot will respond when the event is triggered.",
                        child: SimpleChanceField(
                          chance: _chance,
                          onChanged: (v) {
                            setState(() {
                              _chance = v;
                            });

                            _showSaveChanges();
                          },
                        )
                      ),

                      ...settingsRow(
                        name: "Cooldown",
                        description: "If the bot responds to the event, it will not be able to respond again for some time.",
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Slider(
                            divisions: 36,
                            min: 0,
                            max: 10800000,
                            label: "${(_cooldown/60000).toStringAsFixed(0)} minutes",
                            value: _cooldown.toDouble(),
                            onChanged: (v) {
                              setState(() {
                                _cooldown = v.toInt();
                              });

                              _showSaveChanges();
                            }
                          )
                        )
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30).add(const EdgeInsets.only(bottom: 50)),
                        child: Column(
                          children: [
                            Wrap(
                              alignment: WrapAlignment.center,
                              children: _getVariableList()
                            ),

                            const SizedBox(height: 5),
                            
                            Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                color: DiscordTheme.backgroundColorDarkest,
                                borderRadius: BorderRadius.circular(5)
                              ),
                              width: double.infinity,
                              child: Column(
                                children: _messagesFields()
                              ),
                            )
                          ],
                        ),
                      )
                    ]),

                  ],
                ),
              )
            ],
          ) 
        ),

        Container(
          color: DiscordTheme.backgroundColorDark,
          width: SecondarySideBar.size,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            children: [
              Container(
                padding: const EdgeInsets.only(left: 5, top: 20, bottom: 1),
                child: Text(
                  widget.event is LexiconPrivateEvent ? "USER COOLDOWNS" : "GUILD COOLDOWNS",
                  style: const TextStyle(
                    color: DiscordTheme.lightGray,
                    fontWeight: FontWeight.w500,
                    fontSize: 10
                  )
                )
              ),

              ..._cooldownButtons,
            ],
          ),
        )
      ],
    );
  }
}