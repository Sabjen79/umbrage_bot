import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/components/lexicon/events/lexicon_event.dart';
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
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Container(),
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