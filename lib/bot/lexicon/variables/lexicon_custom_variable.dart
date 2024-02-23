import 'dart:convert';
import 'dart:io';

import 'package:umbrage_bot/bot/lexicon/variables/lexicon_variable.dart';
import 'package:umbrage_bot/bot/util/bot_files.dart';
import 'package:umbrage_bot/bot/util/json_serializable.dart';
import 'package:umbrage_bot/bot/util/pseudo_random_index.dart';

class LexiconCustomVariable extends LexiconVariable with JsonSerializable {
  final List<String> _words;
  late final PseudoRandomIndex _pseudoRandomIndex;
  List<String> get words => _words;
  
  LexiconCustomVariable(super.keyword, super.name, super.description, super.color, this._words) {
    if(_words.isEmpty) return;

    _pseudoRandomIndex = PseudoRandomIndex(_words.length);
  }

  static LexiconCustomVariable fromJson(String filename) {
    File f = File("${BotFiles().getDir("lexicon/variables").path}/$filename");
    var json = jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;

    return LexiconCustomVariable(filename.split('.').first, json['name'], json['description'], json['color'], List<String>.from(json['words']));
  }

  @override
  String getValue() {
    if(words.isEmpty) return "";

    return _words[_pseudoRandomIndex.getNextIndex()];
  }
  
  @override
  String get jsonFilepath => "${BotFiles().getDir("lexicon/variables").path}/$keyword.json";
  
  @override
  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'color': colorInt,
    'words': words
  };
}