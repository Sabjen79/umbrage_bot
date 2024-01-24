import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nyxx/nyxx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:umbrage_bot/bot/bot.dart';

class BotFiles {
  late String _botId;
  late Directory _mainDir;

  // Singleton
  static final BotFiles _instance = BotFiles._init();

  factory BotFiles() {
    return _instance;
  }
    
  BotFiles._init() {
    try {
      _botId = Bot().user.id.toString();
    } catch(e) {
      throw Exception("BotFiles MUST be initialized after the bot initializes his user (for his ID).");
    }

    getApplicationSupportDirectory().then((dir) {
      _mainDir = Directory("${dir.path}/$_botId")..createSync();
    });

    debugPrint("BotFiles initialized.");
  }
  //

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
}