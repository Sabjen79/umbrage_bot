import 'dart:io';
import 'dart:math';
import 'package:umbrage_bot/bot/lexicon/lexicon.dart';
import 'package:umbrage_bot/bot/lexicon/variables/lexicon_variable.dart';
import 'package:umbrage_bot/bot/util/bot_files/bot_files.dart';

abstract class LexiconEvent {
  final Lexicon _lexicon;
  final String _filename;
  final String _name;
  final String _description;
  bool _enabled = false;
  int _cooldown = 0;
  double _chance = 1.0;

  final List<String> _phrases = [];
  final List<LexiconVariable> _variables = [];
  List<int> _phrasesRandomIndexes = [];

  LexiconEvent(this._lexicon, this._filename, this._name, this._description) {
    loadSettingsFromFile();
  }

  String get filename => _filename;
  String get name => _name;
  String get description => _description;
  bool get isEnabled => _enabled;
  int get cooldown => _cooldown;
  double get chance => _chance;
  List<String> get phrases => _phrases;
  List<LexiconVariable> get variables => _variables;

  void addVariables(List<LexiconVariable> v) { _variables.addAll(v); }

  String getPhrase() {
    if(_phrases.isEmpty) return "";

    if(_phrasesRandomIndexes.isEmpty) {
      _phrasesRandomIndexes = List<int>.generate(_phrases.length, (index) => index)..shuffle();
    }

    String phrase = _phrases[_phrasesRandomIndexes.removeAt(0)];

    for(var v in _variables) {
      phrase = phrase.replaceAll("\$${v.keyword}\$", v.getValue());
    }

    for(var v in _lexicon.customVariables) {
      Set<String> usedValues = {};
      while(phrase.contains(v.keyword)) {
        var value = v.getValue();

        if(usedValues.contains(value) && usedValues.length != v.words.length) continue;
        usedValues.add(value);

        phrase = phrase.replaceFirst(v.keyword, value);
      }
    }

    return phrase;
  }

  void loadSettingsFromFile() {
    File f = File("${BotFiles().getDir("lexicon/events").path}/$filename.txt");

    if(!f.existsSync()) {
      String newLine = Platform.lineTerminator;

      f.writeAsStringSync("${_enabled.toString()}$newLine${_chance.toString()}$newLine${_cooldown.toString()}$newLine");
      return;
    }

    try {
      List<String> fileLines = f.readAsLinesSync();

      _enabled = bool.parse(fileLines[0]);
      _chance = double.parse(fileLines[1]);
      _cooldown = int.parse(fileLines[2]);
      _phrases..clear()..addAll(fileLines.sublist(3));
      _phrasesRandomIndexes = List<int>.generate(_phrases.length, (index) => index)..shuffle();

    } catch (e) {
      // Yeah, very insightful description, something is wrong WITH YOU, not with the file
      throw Exception("Something is wrong with the file: $filename.txt"); 
    }
  }
}