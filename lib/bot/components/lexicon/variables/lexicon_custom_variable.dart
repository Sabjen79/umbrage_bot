import 'dart:math';
import 'package:umbrage_bot/bot/components/lexicon/variables/lexicon_variable.dart';
import 'package:umbrage_bot/bot/util/bot_files.dart';

class LexiconCustomVariable extends LexiconVariable {
  List<String> words;

  LexiconCustomVariable(super.token, super.name, super.description, this.words);

  @override
  String getValue() {
    return words.isEmpty ? "" : words[Random().nextInt(words.length)];
  }

  void addWord(String word) {
    if(words.contains(word)) return;

    words.add(word);

    BotFiles().saveLexiconVariable(this);
  }

  void removeWord(String word) {
    if(words.remove(word)) BotFiles().saveLexiconVariable(this);
  }
}