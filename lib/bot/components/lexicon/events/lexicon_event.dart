import 'dart:io';
import 'dart:math';
import 'package:umbrage_bot/bot/components/lexicon/lexicon.dart';
import 'package:umbrage_bot/bot/components/lexicon/variables/lexicon_variable.dart';
import 'package:umbrage_bot/bot/util/bot_files/bot_files.dart';

abstract class LexiconEvent {
  final Lexicon _lexicon;
  final String _filename;
  final String _name;
  final String _description;
  bool _enabled = true;
  int _cooldown = 0;
  double _chance = 1.0;

  final List<String> _phrases = [];
  final List<LexiconVariable> _variables = [];

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

    String phrase = _phrases[Random().nextInt(_phrases.length)];

    for(var v in [..._variables, ..._lexicon.getCustomVariables()]) {
      phrase = phrase.replaceAll("\$${v.getKeyword()}\$", v.getValue());
    }

    return phrase;
  }

  void saveSettingsToFile() {
    File f = File("${BotFiles().getDir("lexicon/events").path}/$filename.txt");

    String newLine = Platform.lineTerminator;
    
    var buffer = StringBuffer("");

    buffer
      ..write("${_enabled.toString()}$newLine")
      ..write("${_cooldown.toString()}$newLine")
      ..write("${_chance.toString()}$newLine");

    for(var p in _phrases) {
      buffer.write("$p$newLine");
    }

    f.writeAsStringSync(buffer.toString());
  }

  void loadSettingsFromFile() {
    File f = File("${BotFiles().getDir("lexicon/events").path}/$filename.txt");

    if(!f.existsSync()) {
      saveSettingsToFile();
      return;
    }

    try {
      List<String> fileLines = f.readAsLinesSync();

      _enabled = bool.parse(fileLines[0]);
      _cooldown = int.parse(fileLines[1]);
      _chance = double.parse(fileLines[2]);
      _phrases..clear()..addAll(fileLines.sublist(3));

    } catch (e) {
      // Yeah, very insightful description, something is wrong WITH YOU, not with the file
      throw Exception("Something is wrong with the file: $filename.txt"); 
    }
  }
}