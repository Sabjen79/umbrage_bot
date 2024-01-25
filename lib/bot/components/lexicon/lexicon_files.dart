import 'dart:io';

import 'package:umbrage_bot/bot/util/bot_files.dart';

abstract class LexiconFiles {
  static void saveToFile(List<String> strings, String folder, String filename) {
    File f = File("${BotFiles().getDir("lexicon/$folder").path}/$filename.txt");

    String newLine = Platform.lineTerminator;
    
    var buffer = StringBuffer("");

    for(var s in strings) {
      buffer.write("$s$newLine");
    }

    f.writeAsStringSync(buffer.toString());
  }

  static List<String> loadFromFile(String folder, String filename) {
    File f = File("${BotFiles().getDir("lexicon/$folder").path}/$filename.txt");

    List<String> strings = [];

    for(var line in f.readAsLinesSync()) {
      if(line.isEmpty) continue;

      strings.add(line);
    }

    return strings;
  }
}