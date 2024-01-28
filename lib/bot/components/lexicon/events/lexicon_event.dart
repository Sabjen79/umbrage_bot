import 'dart:math';
import 'package:umbrage_bot/bot/components/lexicon/lexicon.dart';
import 'package:umbrage_bot/bot/components/lexicon/variables/lexicon_variable.dart';
import 'package:umbrage_bot/bot/util/bot_files/bot_files.dart';

abstract class LexiconEvent {
  final Lexicon lexicon;
  final String filename;
  String name;
  String description;

  final List<String> _phrases;
  final List<LexiconVariable> variables = [];

  LexiconEvent(this.lexicon, this.filename, this.name, this.description, this._phrases);

  List<String> getPhrases() {
    return _phrases;
  }

  void addPhrase(String phrase) {
    if(_phrases.contains(phrase)) return;

    _phrases.add(phrase);

    BotFiles().saveLexiconEvent(this);
  }

  void removePhrase(String phrase) {
    if(_phrases.remove(phrase)) BotFiles().saveLexiconEvent(this);
  }

  String getPhrase() {
    if(_phrases.isEmpty) return "";

    String phrase = _phrases[Random().nextInt(_phrases.length)];

    for(var v in [...variables, ...lexicon.customVariables]) {
      phrase = phrase.replaceAll("\$${v.token}\$", v.getValue());
    }

    return phrase;
  }
}