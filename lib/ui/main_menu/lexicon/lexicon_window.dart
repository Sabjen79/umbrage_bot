import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/ui/main_menu/lexicon/lexicon_add_window.dart';
import 'package:umbrage_bot/ui/main_menu/main_sub_window.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';

class LexiconWindow extends MainWindow {
  LexiconWindow({super.key}) : super("Lexicon", Symbols.quick_phrases) {
    _resetWindows();

    Bot().lexicon.addListener(() {
      _resetWindows();
    });
  }

  void _resetWindows() {
    windows.clear();
    var lexicon = Bot().lexicon;

    var variables = lexicon.getCustomVariables();

    windows.add(LexiconAddWindow());
    
    for(var v in variables) {
      windows.add(EmptyMainSubWindow(v.token), "CUSTOM VARIABLES");
    }

    var events = lexicon.getAllEvents();

    for(var e in events) {
      windows.add(EmptyMainSubWindow(e.name), "EVENTS");
    }
  }
}