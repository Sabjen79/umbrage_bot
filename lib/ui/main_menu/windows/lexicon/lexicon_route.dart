import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/ui/main_menu/windows/lexicon/custom_variables/lexicon_variable_window.dart';
import 'package:umbrage_bot/ui/main_menu/windows/lexicon/events/lexicon_event_window.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_route.dart';

class LexiconRoute extends MainRoute {
  LexiconRoute() : super("lexicon", "Lexicon", Symbols.quick_phrases) {
    Bot().lexicon.addListener(() async {
      refreshWindows();
    });
  }

  @override
  List<MainWindow> defineWindows() {
    var list  = <MainWindow>[];
    var lexicon = Bot().lexicon;

    list.add(LexiconVariableWindow(null));
    
    for(var v in lexicon.customVariables) {
      list.add(LexiconVariableWindow(v));
    }

    var events = lexicon.events;

    for(var e in events) {
      final window = LexiconEventWindow(e);
      list.add(window);

      if(defaultRoute.isEmpty) defaultRoute = window.route;
    }

    return list;
  }
}