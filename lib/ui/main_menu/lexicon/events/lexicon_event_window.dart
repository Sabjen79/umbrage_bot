import 'package:flutter/material.dart';
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

class _LexiconEventWindowState extends State<LexiconEventWindow> {
  bool _enabled = true;

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

  Widget _divider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
      width: double.infinity, 
      height: 1, 
      color: DiscordTheme.gray
    );
  }

  Widget _settingRow({required String name, required String description, required Widget child}) {
    return Container(
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
    );
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
                    _settingRow(
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
                    _divider(),
                    
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