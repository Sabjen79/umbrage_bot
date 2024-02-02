import 'dart:io';

import 'package:flutter/material.dart';
import 'package:umbrage_bot/bot/components/lexicon/events/lexicon_event.dart';
import 'package:umbrage_bot/bot/components/lexicon/events/lexicon_mention_event.dart';
import 'package:umbrage_bot/bot/components/lexicon/variables/lexicon_custom_variable.dart';
import 'package:umbrage_bot/bot/util/bot_files/bot_files.dart';
import 'package:umbrage_bot/bot/util/result.dart';
import 'package:umbrage_bot/ui/main_menu/lexicon/lexicon_variable_window.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_menu_router.dart';

class Lexicon with ChangeNotifier {
  final List<LexiconCustomVariable> _customVariables = [];

  // Always remember to include all events in getAllEvents()!!!
  late final LexiconMentionEvent mentionEvent;

  // Constructor
  Lexicon() {
    final BotFiles files = BotFiles();

    for(var file in files.getDir("lexicon/variables").listSync()) {
      _customVariables.add(
        _loadLexiconVariable(
          file.path.split(RegExp(r'[/\\]+')).last // Splits path by '/' and '\'
        )
      );
    }

    mentionEvent = LexiconMentionEvent(this, _loadLexiconEventPhrases("mention_bot.txt"));
  }
  //

  // Event Getters
  LexiconEvent? getEvent<T extends LexiconEvent>() {
    if(T.toString() == "LexiconEvent") throw Exception("Lexicon.getEvent() should be called with a generic type included");

    for(var event in getAllEvents()) {
      if(event is T) {
        return event;
      }
    }
    return null;
  }

  List<LexiconEvent> getAllEvents() {
    return <LexiconEvent>[
      mentionEvent
    ];
  }

  // Custom Variables

  List<LexiconCustomVariable> getCustomVariables() {
    return _customVariables;
  }

  Result<LexiconCustomVariable> createCustomVariable(String keyword, String name, String description, int color, List<String> words) {
    var result = _createVariable(keyword, name, description, color, words);

    if(result.isSuccess) {
      _customVariables.add(result.value!);
      _saveLexiconVariable(result.value!);
      notifyListeners();
    }

    return result;
  }

  Result<LexiconCustomVariable> updateCustomVariable(LexiconCustomVariable oldVariable, String keyword, String name, String description, int color, List<String> words) {
    var result = _createVariable(keyword, name, description, color, words, oldVariable);

    if(result.isSuccess) {
      int index = _customVariables.indexOf(oldVariable);
      _customVariables[index] = result.value!;

      BotFiles().deleteFile("lexicon/variables/${oldVariable.getKeyword()}.txt");
      _saveLexiconVariable(result.value!);

      notifyListeners();
    }

    return result;
  }

  void deleteCustomVariable(LexiconCustomVariable variable) {
    if(!_customVariables.remove(variable)) return;

    BotFiles().deleteFile("lexicon/variables/${variable.getKeyword()}.txt");

    notifyListeners();
  }

  void _saveLexiconVariable(LexiconCustomVariable v) {
    _lexiconSaveToFile([v.getName(), v.getDescription(), v.getColorInt().toString(), ...v.getWords()], "variables", v.getKeyword());
  }

  Result<LexiconCustomVariable> _createVariable(String keyword, String name, String description, int color, List<String> words, [LexiconCustomVariable? oldVariable]) {
    if(name.isEmpty || name.replaceAll(" ", "").isEmpty) return Result.failure("Name cannot be empty.");
    if(RegExp(r'[^\w]').hasMatch(keyword)) return Result.failure("Name and Keyword cannot contain any character besides underscores.");
    if(description.isNotEmpty && description.replaceAll(" ", "").isEmpty) return Result.failure("Description contains only whitespaces. Make it empty or write something!");

    for(var w in MainMenuRouter().getActiveMainRoute().getWindows()) {
      if(w is! LexiconVariableWindow && (keyword == "add_variable" || keyword == w.route)) return Result.failure("'$keyword' is a restricted keyword used that would cause errors.");
    }

    for(var v in _customVariables) {
      if(oldVariable == v) continue;
      if(v.getKeyword() == keyword) return Result.failure("There is another variable with the same keyword. Change it!");
    }

    for(var w in words) {
      if(w.isEmpty || w.replaceAll(" ", "").isEmpty) return Result.failure("One or more words are empty.");
    }

    return Result.success(LexiconCustomVariable(keyword, name, description, color, words));
  }

  LexiconCustomVariable _loadLexiconVariable(String filename) {
    var strings = _lexiconLoadFromFile("variables", filename);

    return LexiconCustomVariable(filename.split('.')[0], strings[0], strings[1], int.parse(strings[2]), strings.sublist(3));
  }

  void _saveLexiconEvent(LexiconEvent p) {
    _lexiconSaveToFile(p.getPhrases(), "events", p.filename);
  }

  List<String> _loadLexiconEventPhrases(String filename) {
    return _lexiconLoadFromFile("events", filename);
  }

  //

  void _lexiconSaveToFile(List<String> strings, String folder, String filename) {
    File f = File("${BotFiles().getDir("lexicon/$folder").path}/$filename.txt");

    String newLine = Platform.lineTerminator;
    
    var buffer = StringBuffer("");

    for(var s in strings) {
      buffer.write("$s$newLine");
    }

    f.writeAsStringSync(buffer.toString());
  }

  List<String> _lexiconLoadFromFile(String folder, String filename) {
    File f = File("${BotFiles().getDir("lexicon/$folder").path}/$filename");

    if(!f.existsSync()) {
      _lexiconSaveToFile([], folder, filename);
      return [];
    }

    List<String> strings = [];

    for(var line in f.readAsLinesSync()) {
      strings.add(line);
    }

    return strings;
  }
}