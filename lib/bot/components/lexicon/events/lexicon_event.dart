import 'dart:math';
import 'package:umbrage_bot/bot/components/lexicon/lexicon.dart';
import 'package:umbrage_bot/bot/components/lexicon/variables/lexicon_variable.dart';

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

  String getPhrase() {
    if(_phrases.isEmpty) return "";

    String phrase = _phrases[Random().nextInt(_phrases.length)];

    for(var v in [...variables, ...lexicon.getCustomVariables()]) {
      phrase = phrase.replaceAll("\$${v.keyword}\$", v.getValue());
    }

    return phrase;
  }
}