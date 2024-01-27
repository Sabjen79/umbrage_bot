import 'package:flutter/material.dart';
import 'package:umbrage_bot/ui/main_menu/main_menu_sub_window.dart';
import 'package:umbrage_bot/ui/main_menu/main_menu_window.dart';

class BotProfileWindow extends MainMenuWindow {
  BotProfileWindow({super.key}) : super("Bot Profile", null, [
    MainMenuSubWindow(categoryName: "", name: "", widget: Container()),
  ]);
}