import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/ui/main_menu/lexicon/custom_variables/lexicon_variable_window.dart';
import 'package:umbrage_bot/ui/main_menu/lexicon/events/lexicon_event_window.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_route.dart';

class LexiconWindow extends MainRoute {
  LexiconWindow() : super("lexicon", "Lexicon", Symbols.quick_phrases) {
    Bot().lexicon.addListener(() {
      refreshWindows();
    });
  }

  @override
  Future<List<MainWindow>> defineWindows() async {
    var list  = <MainWindow>[];
    var lexicon = Bot().lexicon;

    list.add(LexiconVariableWindow(null));
    
    for(var v in lexicon.customVariables) {
      list.add(LexiconVariableWindow(v));
    }

    var events = lexicon.events;

    for(var e in events) {
      list.add(LexiconEventWindow(e));
    }

    return list;
  }
}