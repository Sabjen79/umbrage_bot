import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/conversation/conversation_delimiters.dart';
import 'package:umbrage_bot/bot/lexicon/events/lexicon_event.dart';
import 'package:umbrage_bot/bot/lexicon/variables/lexicon_variable.dart';
import 'package:umbrage_bot/ui/components/simple_chance_field.dart';
import 'package:umbrage_bot/ui/components/simple_discord_dialog.dart';
import 'package:umbrage_bot/ui/components/simple_switch.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';
import 'package:umbrage_bot/ui/main_menu/lexicon/events/lexicon_event_phrase_field.dart';
import 'package:umbrage_bot/ui/main_menu/lexicon/events/lexicon_event_status.dart';
import 'package:umbrage_bot/ui/main_menu/lexicon/events/lexicon_event_variable_button.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_menu_router.dart';
import 'package:umbrage_bot/ui/main_menu/secondary_side_bar/secondary_side_bar.dart';

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

class _LexiconEventWindowState extends State<LexiconEventWindow> with TickerProviderStateMixin {
  late bool _enabled;
  late double _chance;
  late int _cooldown;
  late List<String> _phrases;

  late List<LexiconVariable> _variables;
  
  late TextEditingController _cooldownControllerHour, _cooldownControllerMinutes, _cooldownControllerSeconds;

  void init() {
    _variables = [...widget.event.variables, ...Bot().lexicon.customVariables];
    _enabled = widget.event.enabled;
    _chance = widget.event.chance;
    _cooldown = widget.event.cooldown;
    _phrases = widget.event.phrases.toList();

    _cooldownControllerHour = TextEditingController();
    _cooldownControllerMinutes = TextEditingController();
    _cooldownControllerSeconds = TextEditingController();
    _resetCooldownControllers();
  }

  void _resetCooldownControllers() {
    double d = _cooldown + 0.0;
    _cooldownControllerHour.text = (d ~/ 3600).toString();
    d = (d / 3600) % 1;
    _cooldownControllerMinutes.text = (d * 60).toStringAsFixed(0);
    d = (d * 60) % 1;
    _cooldownControllerSeconds.text = (d * 60).toStringAsFixed(0);
  }

  void _setCooldown() {
    _cooldown = 
      int.parse('0${_cooldownControllerHour.text}') * 3600 +
      int.parse('0${_cooldownControllerMinutes.text}') * 60 +
      int.parse('0${_cooldownControllerSeconds.text}');
  }

  Widget _getVariableListDivider(String text) {
    return Container(
      padding: const EdgeInsets.only(left: 5, top: 20, bottom: 1),
      child: Text(
        text,
        style: const TextStyle(
          color: DiscordTheme.lightGray,
          fontWeight: FontWeight.w500,
          fontSize: 10
        )
      )
    );
  }

  List<Widget> _getVariableList() {
    var list = <Widget>[];

    list.add(_getVariableListDivider("MESSAGE DELIMITERS"));

    for(var d in ConversationDelimiters.values) {
      list.add(LexiconEventVariableButton(
        keyword: d.delimiter,
        name: d.name,
        description: d.description,
        color: DiscordTheme.white2
      ));
    }

    list.add(_getVariableListDivider("EVENT VARIABLES"));

    for(var v in widget.event.variables) {
      list.add(LexiconEventVariableButton(
        keyword: "\$${v.keyword}\$",
        name: v.name,
        description: v.description,
        color: v.color
      ));
    }

    if(Bot().lexicon.customVariables.isNotEmpty) list.add(_getVariableListDivider("CUSTOM VARIABLES"));

    for(var v in Bot().lexicon.customVariables) {
      list.add(LexiconEventVariableButton(
        keyword: "\$${v.keyword}\$",
        name: v.name,
        description: v.description,
        color: v.color
      ));
    }

    return list;
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

  List<Widget> _cooldownInput(TextEditingController controller, String regex, String text) {
    return [
      SizedBox(
        width: 34,
        child: TextField(
          maxLength: 2,
          textAlign: TextAlign.end,
          controller: controller,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 7, horizontal: 4),
            counter: SizedBox(),
          ),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(regex), replacementString: "er"),
          ],
          onChanged: (v) {
            if(v == "er") {
              _resetCooldownControllers();
              return;
            }

            setState(() {
              _setCooldown();
            });

            _showSaveChanges();
          },
        ),
      ),

      Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 4, right: 7),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500),),
      )
    ];
  }

  List<Widget> _settingRow({required String name, required String description, required Widget child}) {
    return [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: DiscordTheme.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500
                    )
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      color: DiscordTheme.white2,
                      fontSize: 10,
                      fontWeight: FontWeight.w400
                    )
                  )
                ],
              ),
            ),

            Align(
              alignment: Alignment.centerRight,
              child: child,
            )
          ],
        )
      ),
      Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
        width: double.infinity, 
        height: 1, 
        color: DiscordTheme.gray
      )
    ];
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
                    ..._settingRow(
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

                    ...(!_enabled ? [] : _settingRow(
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
                    )),

                    ...(!_enabled ? [] : _settingRow(
                      name: "Cooldown",
                      description: "If the bot responds to the event, it will not be able to respond again for some time.",
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ..._cooldownInput(_cooldownControllerHour, r'^\d?\d?$', "Hours"),
                            ..._cooldownInput(_cooldownControllerMinutes, r'^[0-5]?\d?$', "Minutes"),
                            ..._cooldownInput(_cooldownControllerSeconds, r'^[0-5]?\d?$', "Seconds"),
                          ],
                        )
                      )
                    )),
                    
                    !_enabled ? Container() : Container(
                      clipBehavior: Clip.hardEdge,
                      margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
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
            ],
          ) 
        ),

        Container(
          color: DiscordTheme.backgroundColorDark,
          width: SecondarySideBar.size,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            children: [
              const Text(
                "Press on variables to copy their keyword to clipboard",
                textAlign: TextAlign.center,
                style: TextStyle(color: DiscordTheme.lightGray),
              ),

              ..._getVariableList(),
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