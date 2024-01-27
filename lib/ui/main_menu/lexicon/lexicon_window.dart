import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/ui/main_menu/main_menu_sub_window.dart';
import 'package:umbrage_bot/ui/main_menu/main_menu_window.dart';

class LexiconWindow extends MainMenuWindow {
  LexiconWindow({super.key}) : super("Lexicon", Symbols.quick_phrases, [
    MainMenuSubWindow(categoryName: "", name: "dab1", widget: Container()),
    MainMenuSubWindow(categoryName: "", name: "dab2", widget: Container()),
    MainMenuSubWindow(categoryName: "category1", name: "dab2", widget: Container()),
    MainMenuSubWindow(categoryName: "category1", name: "dab2", widget: Container()),
    MainMenuSubWindow(categoryName: "category1", name: "dab2", widget: Container()),
    MainMenuSubWindow(categoryName: "category2", name: "dab2", widget: Container()),
    MainMenuSubWindow(categoryName: "category2", name: "dab3", widget: Container())
  ]);
}