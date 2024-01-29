import 'package:umbrage_bot/ui/main_menu/main_sub_window.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';

class BotProfileWindow extends MainWindow {
  BotProfileWindow({super.key}) : super("Bot Profile", null) {
    windows.add(EmptyMainSubWindow("Profile"));
  }
}