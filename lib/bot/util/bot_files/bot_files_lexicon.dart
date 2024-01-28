import 'dart:io';
import 'package:umbrage_bot/bot/components/lexicon/events/lexicon_event.dart';
import 'package:umbrage_bot/bot/components/lexicon/variables/lexicon_custom_variable.dart';
import 'package:umbrage_bot/bot/util/bot_files/bot_files.dart';

mixin BotFilesLexicon {
  void saveLexiconVariable(LexiconCustomVariable v) {
    _lexiconSaveToFile([v.name, v.description, ...v.words], "variables", v.token);
  }

  LexiconCustomVariable loadLexiconVariable(String filename) {
    var strings = _lexiconLoadFromFile("variables", filename);

    return LexiconCustomVariable(filename.split('.')[0], strings[0], strings[1], strings.sublist(2));
  }

  void saveLexiconEvent(LexiconEvent p) {
    _lexiconSaveToFile(p.getPhrases(), "events", p.filename);
  }

  List<String> loadLexiconEventPhrases(String filename) {
    return _lexiconLoadFromFile("events", filename);
  }

  //

  void _lexiconSaveToFile(List<String> strings, String folder, String filename) {
    File f = File("${BotFiles().getDir("lexicon/$folder").path}/$filename");

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
      if(line.isEmpty) continue;

      strings.add(line);
    }

    return strings;
  }
}