import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/lexicon/conversation/conversation_delimiters.dart';
import 'package:umbrage_bot/bot/lexicon/events/lexicon_event.dart';
import 'package:umbrage_bot/bot/lexicon/events/lexicon_private_event.dart';
import 'package:umbrage_bot/bot/lexicon/variables/lexicon_variable.dart';
import 'package:umbrage_bot/ui/components/simple_chance_field.dart';
import 'package:umbrage_bot/ui/components/simple_discord_dialog.dart';
import 'package:umbrage_bot/ui/components/simple_switch.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';
import 'package:umbrage_bot/ui/main_menu/windows/lexicon/events/lexicon_event_cooldown_button.dart';
import 'package:umbrage_bot/ui/main_menu/windows/lexicon/events/lexicon_event_phrase_field.dart';
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
  late List<String> _phrases;

  late List<LexiconVariable> _variables;
  late List<LexiconEventCooldownButton> _cooldownButtons;
  StreamSubscription? _subscription;

  void init() {
    _variables = [...widget.event.variables, ...Bot().lexicon.customVariables];
    _enabled = widget.event.enabled;
    _chance = widget.event.chance;
    _cooldown = widget.event.cooldown;
    _phrases = widget.event.phrases.toList();
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
      var result = Bot().lexicon.updateLexiconEvent(widget.event.filename, _enabled, _chance, _cooldown, _phrases);

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

    for(var d in ConversationDelimiters.values) {
      list.add(LexiconEventVariablePill(
        keyword: d.delimiter,
        name: d.name,
        description: d.description,
        color: DiscordTheme.white2
      ));
    }

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

  List<Widget> _phraseFields() {
    var list = <Widget>[];

    for(int i = 0; i < _phrases.length; i++) {
      list.add(
        LexiconEventPhraseField(
          initialText: _phrases[i],
          variables: _variables,
          onChanged: (value) {
            if(value == _phrases[i]) return;

            _phrases[i] = value;

            _showSaveChanges();
          },
          onDelete: () {

            setState(() {
              _phrases.removeAt(i);
            });

            _showSaveChanges();
          },
        )
      );

      list.add(Container(color: DiscordTheme.gray, width: double.infinity, height: 1));
    }

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
                        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
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
                                children: [
                                  ..._phraseFields(),
                                  _AddPhraseWidget(
                                    onTap: () {
                                      setState(() {
                                        _phrases.add("");
                                      });

                                      _showSaveChanges();
                                    },
                                  )
                                ],
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

class _AddPhraseWidget extends StatefulWidget {
  final VoidCallback onTap;

  const _AddPhraseWidget({required this.onTap});

  @override
  State<_AddPhraseWidget> createState() => _AddPhraseWidgetState();
}

class _AddPhraseWidgetState extends State<_AddPhraseWidget> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
    onTap: widget.onTap,
    onHover: (b) {
      setState(() {
        _hover = b;
      });
    },
    child: Container(
      color: _hover ? DiscordTheme.backgroundColorDarker : DiscordTheme.backgroundColorDarkest,
      height: 40,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10, right: 3),
            child: Icon(
              Symbols.add,
              size: 25,
              opticalSize: 20,
              color: DiscordTheme.lightGray,
            )
          ),

          Padding(
            padding: EdgeInsets.only(bottom: 1),
            child: Text(
              "Add New Phrase", 
              style: TextStyle(
                color: DiscordTheme.lightGray,
                fontWeight: FontWeight.w500
              ),
            ),
          )
        ],
      ),
    ),
  );
  }
}