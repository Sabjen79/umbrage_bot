import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/components/lexicon/variables/lexicon_custom_variable.dart';
import 'package:umbrage_bot/ui/main_menu/main_sub_window.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';

class LexiconWindow extends MainWindow {
  LexiconWindow({super.key}) : super("Lexicon", Symbols.quick_phrases) {
    _resetWindows();

    Bot().lexicon.addListener(_resetWindows);
  }

  void _resetWindows() {
    windows.clear();

    var variables = Bot().lexicon.customVariables;

    windows.add(MainSubWindow(
      categoryName: "CUSTOM VARIABLES",
      sideBarIcon: Symbols.add_circle,
      name: "Add New Variable",
      widget: Container()
    ));
    
    for(var v in variables) {
      windows.add(MainSubWindow(
        categoryName: "CUSTOM VARIABLES", 
        name: v.name,
        widget: Container()
      ));
    }

    var events = Bot().lexicon.getAllEvents();

    for(var e in events) {
      windows.add(
        MainSubWindow(
          categoryName: "EVENTS", 
          name: e.name, 
          sideBarIcon: Symbols.event,
          widget: InkWell(
            onTap: () {
              Bot().lexicon.addCustomVariable(LexiconCustomVariable("test", "test", "test", []));
            },
            child: Container(width: 100, height: 100, color: Colors.red),
          )
        )
      );
    }
  }
}