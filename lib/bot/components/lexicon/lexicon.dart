import 'dart:io';

import 'package:flutter/material.dart';
import 'package:umbrage_bot/bot/components/lexicon/events/lexicon_event.dart';
import 'package:umbrage_bot/bot/components/lexicon/events/lexicon_mention_event.dart';
import 'package:umbrage_bot/bot/components/lexicon/variables/lexicon_custom_variable.dart';
import 'package:umbrage_bot/bot/util/bot_files/bot_files.dart';

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

  void addCustomVariable(LexiconCustomVariable variable) {
    _customVariables.add(variable);

    _saveLexiconVariable(variable);

    notifyListeners();
  }

  void deleteCustomVariable(LexiconCustomVariable variable) {
    if(!_customVariables.remove(variable)) return;

    BotFiles().deleteFile("lexicon/variables/${variable.keyword}.txt");

    notifyListeners();
  }

  void updateCustomVariable(LexiconCustomVariable oldVariable, LexiconCustomVariable newVariable) {
    int index = _customVariables.indexOf(oldVariable);
    _customVariables[index] = newVariable;

    BotFiles().deleteFile("lexicon/variables/${oldVariable.keyword}.txt");
    _saveLexiconVariable(newVariable);

    notifyListeners();
  }

  void _saveLexiconVariable(LexiconCustomVariable v) {
    _lexiconSaveToFile([v.name, v.description, v.color, ...v.words], "variables", v.keyword);
  }

  LexiconCustomVariable _loadLexiconVariable(String filename) {
    var strings = _lexiconLoadFromFile("variables", filename);

    return LexiconCustomVariable(filename.split('.')[0], strings[0], strings[1], strings[2], strings.sublist(3));
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