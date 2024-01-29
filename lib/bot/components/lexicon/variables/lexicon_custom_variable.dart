import 'dart:math';
import 'package:umbrage_bot/bot/components/lexicon/variables/lexicon_variable.dart';

class LexiconCustomVariable extends LexiconVariable {
  List<String> words;

  LexiconCustomVariable(super.token, super.name, super.description, this.words);

  @override
  String getValue() {
    return words.isEmpty ? "" : words[Random().nextInt(words.length)];
  }
}