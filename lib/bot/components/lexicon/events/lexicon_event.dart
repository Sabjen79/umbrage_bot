import 'dart:math';
import 'package:flutter/material.dart';
import 'package:umbrage_bot/bot/components/lexicon/variables/lexicon_variable.dart';
import 'package:umbrage_bot/bot/util/bot_files.dart';

abstract class LexiconEvent {
  final String filename;
  String name;
  String description;

  final List<String> _phrases;

  @protected
  final List<LexiconVariable> variables = [];

  LexiconEvent(this.filename, this.name, this.description, this._phrases);

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

  String computePhrase(List<LexiconVariable> customVariables) {
    if(_phrases.isEmpty) return "";

    String phrase = _phrases[Random().nextInt(_phrases.length)];

    for(var v in [...variables, ...customVariables]) {
      phrase.replaceAll("\$${v.token}\$", v.computeVariable());
    }

    return phrase;
  }
}