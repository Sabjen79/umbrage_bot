import 'dart:convert';
import 'dart:io';

import 'package:umbrage_bot/bot/lexicon/variables/lexicon_variable.dart';
import 'package:umbrage_bot/bot/util/bot_files/bot_files.dart';
import 'package:umbrage_bot/bot/util/json_serializable.dart';

class LexiconCustomVariable extends LexiconVariable with JsonSerializable {
  final List<String> _words;
  List<int> _randomizedWordsIndexes = [];
  List<String> get words => _words;
  
  LexiconCustomVariable(super.keyword, super.name, super.description, super.color, this._words) {
    if(_words.isEmpty) return;

    _randomizedWordsIndexes = List<int>.generate(_words.length, (index) => index)..shuffle();
  }

  static LexiconCustomVariable fromJson(String filename) {
    File f = File("${BotFiles().getMainDir().path}/lexicon/variables/$filename");
    var json = jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;

    return LexiconCustomVariable(filename.split('.').first, json['name'], json['description'], json['color'], List<String>.from(json['words']));
  }

  @override
  String getValue() {
    if(words.isEmpty) return "";

    if(_randomizedWordsIndexes.isEmpty) _randomizedWordsIndexes = List<int>.generate(_words.length, (index) => index)..shuffle();

    return _words[_randomizedWordsIndexes.removeAt(0)];
  }
  
  @override
  String get jsonFilepath => "${BotFiles().getMainDir().path}/lexicon/variables/$keyword.json";
  
  @override
  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'color': colorInt,
    'words': words
  };
}