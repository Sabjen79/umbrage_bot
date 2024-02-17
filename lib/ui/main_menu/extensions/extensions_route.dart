import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_route.dart';

class ExtensionsRoute extends MainRoute {
  ExtensionsRoute() : super("extensions", "Extensions", Symbols.mindfulness);

  @override
  Future<List<MainWindow>> defineWindows() async {
    var list  = <MainWindow>[];

    return list;
  }
}