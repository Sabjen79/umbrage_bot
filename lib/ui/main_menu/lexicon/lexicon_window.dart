import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/ui/main_menu/lexicon/lexicon_variable_window.dart';
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

    addWindow(LexiconVariableWindow(null));
    
    for(var v in variables) {
      addWindow(LexiconVariableWindow(v));
    }

    var events = lexicon.getAllEvents();

    for(var e in events) {
      addWindow(EmptyMainSubWindow(e.filename, "EVENTS", e.name));
    }
  }
}