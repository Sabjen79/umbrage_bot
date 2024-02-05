import 'dart:math';
import 'package:umbrage_bot/bot/lexicon/variables/lexicon_variable.dart';

class LexiconCustomVariable extends LexiconVariable {
  final List<String> _words;
  List<int> _randomizedWordsIndexes = [];
  List<String> get words => _words;
  

  LexiconCustomVariable(super.keyword, super.name, super.description, super.color, this._words) {
    if(_words.isEmpty) return;

    _randomizedWordsIndexes = List<int>.generate(_words.length, (index) => index)..shuffle();
  }

  @override
  String getValue() {
    if(words.isEmpty) return "";

    if(_randomizedWordsIndexes.isEmpty) _randomizedWordsIndexes = List<int>.generate(_words.length, (index) => index)..shuffle();

    return _words[_randomizedWordsIndexes.removeAt(0)];
  }
}