import 'package:umbrage_bot/ui/main_menu/bot_profile/bot_profile_widget.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_route.dart';

class BotProfileWindow extends MainRoute {
  BotProfileWindow() : super("profile", "Bot Profile", null, false);

  @override
  Future<List<MainWindow>> defineWindows() async {
    var list  = <MainWindow>[];

    list.add(const BotProfileWidget());

    return list;
  }
}