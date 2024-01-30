import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/ui/main_menu/lexicon/lexicon_add_window.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_route.dart';

class LexiconWindow extends MainRoute {
  LexiconWindow() : super("lexicon", "Lexicon", Symbols.quick_phrases) {
    _resetWindows();

    Bot().lexicon.addListener(() {
      _resetWindows();
    });
  }

  void _resetWindows() {
    clearWindows();
    var lexicon = Bot().lexicon;

    var variables = lexicon.getCustomVariables();

    addWindow(LexiconAddWindow());
    
    for(var v in variables) {
      addWindow(EmptyMainSubWindow(v.keyword, "CUSTOM VARIABLES", v.keyword));
    }

    var events = lexicon.getAllEvents();

    for(var e in events) {
      addWindow(EmptyMainSubWindow(e.name, "EVENTS", e.name));
    }
  }
}