import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/ui/main_menu/console/console_window.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_route.dart';

class ConsoleRoute extends MainRoute {
  ConsoleRoute() : super("console", "Console", Symbols.terminal, false);

  @override
  Future<List<MainWindow>> defineWindows() async {
    return [const ConsoleWindow()];
  }
}