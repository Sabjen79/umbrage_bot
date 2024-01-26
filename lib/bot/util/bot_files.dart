import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nyxx/nyxx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/components/lexicon/events/lexicon_event.dart';
import 'package:umbrage_bot/bot/components/lexicon/variables/lexicon_custom_variable.dart';

class BotFiles {
  late String _botId;
  late Directory _mainDir;

  // Singleton
  static final BotFiles _instance = BotFiles._init();

  factory BotFiles() {
    return _instance;
  }
    
  BotFiles._init();
  //

  Future<void> initialize() async {
    try {
      _botId = Bot().user.id.toString();
    } catch(e) {
      throw Exception("BotFiles MUST be initialized after the bot initializes his user (for his ID).");
    }

    var dir = await getApplicationSupportDirectory();

    _mainDir = Directory("${dir.path}/$_botId");
    _mainDir.createSync();

    debugPrint("BotFiles initialized.");
  }

  Directory getMainDir() {
    return _mainDir;
  }

  Directory getDir(String name) {
    var d = Directory("${_mainDir.path}/$name");

    d.createSync(recursive: true);
    
    return d;
  }

  // If additional dir is not passed, returns 'guilds/$id', otherwise it returns 'guilds/$id/$dir'
  Directory getDirForGuild(PartialGuild g, {String dir = ""}) {
    return getDir("guilds/${g.id}${dir == "" ? "" : "/$dir"}"); 
  }

  void deleteFile(String path) {
    File f = File("${_mainDir.path}/$path");
    
    f.deleteSync();
  }

  // TO-DO: Implement mixins for different uses

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