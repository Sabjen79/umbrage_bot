import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/components/lexicon/events/lexicon_event.dart';
import 'package:umbrage_bot/ui/components/simple_switch.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';
import 'package:umbrage_bot/ui/main_menu/lexicon/events/lexicon_event_variable_button.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';
import 'package:umbrage_bot/ui/main_menu/secondary_side_bar/secondary_side_bar.dart';

class LexiconEventWindow extends MainWindow {
  final LexiconEvent event;

  LexiconEventWindow(this.event, {super.key}) : super(
    name: event.name,
    route: event.filename,
    sideBarIcon: Symbols.event,
    category: "EVENTS",
  );

  @override
  State<LexiconEventWindow> createState() => _LexiconEventWindowState();
}

class _LexiconEventWindowState extends State<LexiconEventWindow> with TickerProviderStateMixin {
  late bool _enabled;
  late double _chance;
  late Widget _changeInput;

  late TextEditingController _chanceController;
  String _chanceString() => _chance > 0.999 ? (_chance*100).toStringAsFixed(0) : (_chance*100).toStringAsFixed(2);

  void init() {
    _enabled = widget.event.isEnabled;
    _chance = widget.event.chance;

    _chanceController = TextEditingController(text: (_chance*100).toString());
    _changeInput = TextField(
      maxLength: 5,
      textAlign: TextAlign.end,
      controller: _chanceController,
      decoration: const InputDecoration(
        suffixText: "%",
        counter: SizedBox(),
      ),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'^(100(?:\.(0)*)?|\d?\d(?:\.\d*?)?)$'), replacementString: "regex"),
      ],
      onChanged: (v) {
        if(v == "regex") {
          _chanceController.text = _chanceString();
          return;
        }

        setState(() {
          _chance = v.isEmpty ? 0 : double.parse(v)/100.0;
        });
      },
    );
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

    list.add(_getVariableListDivider("EVENT VARIABLES"));

    for(var v in widget.event.variables) {
      list.add(LexiconEventVariableButton(variable: v));
    }

    list.add(_getVariableListDivider("CUSTOM VARIABLES"));

    for(var v in Bot().lexicon.getCustomVariables()) {
      list.add(LexiconEventVariableButton(variable: v));
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

  @override
  void dispose() {
    _chanceController.dispose();
    super.dispose();
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
            Column(
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

            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: child,
              )
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
                height: 100,
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
                padding: const EdgeInsets.only(top: 100),
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
                        }
                      )
                    ),

                    ..._settingRow(
                      name: "Chance",
                      description: "The chance that the bot will respond when the event is triggered.",
                      child: SizedBox(
                        width: 400,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Slider(
                                value: _chance,
                                max: 1.0,
                                onChanged: (v) {
                                  setState(() {
                                    _chance = double.parse(v.toStringAsFixed(2));
                                    _chanceController.text = _chanceString();
                                  });
                                },
                              )
                            ),
                            SizedBox(
                              width: 75,
                              child: _changeInput,
                            )
                            
                          ]
                        )
                      )
                    ),

                    ..._settingRow(
                      name: "Cooldown",
                      description: "If the bot responds to the event, it will not be able to respond again for some time.",
                      child: SizedBox(
                        width: 100,
                        child: TextField(
                          textAlign: TextAlign.end,
                          controller: _chanceController, // TO-DO: cooldown
                          decoration: const InputDecoration(
                            suffixText: "%",
                            counter: SizedBox(),
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'^(?:\d?\d(\:[0-5]?\d?|[0-5]\d\:){0,2})$'), replacementString: "regex"),
                          ],
                          onChanged: (v) {
                            if(v == "regex") {
                              _chanceController.text = _chanceString();
                              return;
                            }

                            setState(() {
                              _chance = v.isEmpty ? 0 : double.parse(v)/100.0;
                            });
                          },
                        )
                      )
                    ),
                    
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