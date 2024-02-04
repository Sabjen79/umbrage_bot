import 'dart:math';
import 'package:umbrage_bot/bot/lexicon/variables/lexicon_variable.dart';

class LexiconCustomVariable extends LexiconVariable {
  List<String> _words;

  List<String> getWords() => _words;

  LexiconCustomVariable(super.keyword, super.name, super.description, super.color, this._words);

  @override
  String getValue() {
    return _words.isEmpty ? "" : _words[Random().nextInt(_words.length)];
  }
}