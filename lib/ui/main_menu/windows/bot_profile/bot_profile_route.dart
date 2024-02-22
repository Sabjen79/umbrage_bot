import 'package:umbrage_bot/ui/main_menu/windows/bot_profile/bot_profile_widget.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_route.dart';

class BotProfileRoute extends MainRoute {
  BotProfileRoute() : super("profile", "Bot Profile", null, false);

  @override
  List<MainWindow> defineWindows() {
    var list  = <MainWindow>[];

    list.add(const BotProfileWidget());

    return list;
  }
}