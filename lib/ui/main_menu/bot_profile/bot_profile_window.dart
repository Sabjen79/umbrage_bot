import 'package:umbrage_bot/ui/main_menu/main_window.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_route.dart';

class BotProfileWindow extends MainRoute {
  BotProfileWindow() : super("profile", "Bot Profile", null) {
    addWindow(EmptyMainSubWindow("profile", "", "Profile"));
  }
}