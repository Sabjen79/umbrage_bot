import 'dart:io';
import 'dart:math';
import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/conversation/conversation.dart';
import 'package:umbrage_bot/bot/lexicon/lexicon.dart';
import 'package:umbrage_bot/bot/lexicon/variables/lexicon_variable.dart';
import 'package:umbrage_bot/bot/util/bot_files/bot_files.dart';
import 'package:umbrage_bot/bot/util/json_serializable.dart';

abstract class LexiconEvent<T extends DispatchEvent> with JsonSerializable {
  final Lexicon _lexicon;
  final String _filename;
  final String _name;
  final String _description;
  bool enabled = false;
  int cooldown = 600;
  double chance = 0.5;

  final List<String> _phrases = [];
  final List<LexiconVariable> _variables = [];
  List<int> _phrasesRandomIndexes = [];
  int _cooldownEnd = 0;

  LexiconEvent(this._lexicon, this._filename, this._name, this._description) {
    var json = loadFromJson();
    if(json == null) return;

    enabled = json['enabled'] as bool;
    cooldown = json['cooldown'] as int;
    chance = json['chance'] as double;
    _phrases..clear()..addAll(List<String>.from(json['phrases']));
  }

  @override
  String get jsonFilepath => "${BotFiles().getMainDir().path}/lexicon/events/$filename.json";

  @override
  Map<String, dynamic> toJson() => {
    'enabled': enabled,
    'cooldown': cooldown,
    'chance': chance,
    'phrases': _phrases
  };

  Future<bool> handleEvent(DispatchEvent event) async {
    if(event is! T || !await validateEvent(event) || !canRun) return false;

    _cooldownEnd = DateTime.now().millisecondsSinceEpoch + cooldown*1000;

    var conv = await buildConversation(event);
    _lexicon.conversations[conv.channel.id] = conv
            ..sendMessage();
      
    return true;
  }

  Future<bool> validateEvent(T event);
  Future<Conversation> buildConversation(T event);

  String get filename => _filename;
  String get name => _name;
  String get description => _description;
  List<String> get phrases => _phrases;
  List<LexiconVariable> get variables => _variables;

  bool get onCooldown => DateTime.now().millisecondsSinceEpoch < _cooldownEnd;
  int get cooldownLeft => !onCooldown ? 0 : _cooldownEnd - DateTime.now().millisecondsSinceEpoch;
  bool get canRun => enabled && !onCooldown && Random().nextDouble() <= chance;

  void endCooldown() {
    _cooldownEnd = 0;
  }

  String getPhrase() {
    if(_phrases.isEmpty) return "";

    if(_phrasesRandomIndexes.isEmpty) {
      _phrasesRandomIndexes = List<int>.generate(_phrases.length, (index) => index)..shuffle();
    }

    String phrase = _phrases[_phrasesRandomIndexes.removeAt(0)].replaceAll("\\n", Platform.lineTerminator);

    for(var v in _variables) {
      phrase = phrase.replaceAll("\$${v.keyword}\$", v.getValue());
    }

    for(var v in _lexicon.customVariables) {
      Set<String> usedValues = {};
      while(phrase.contains(v.keyword)) {
        var value = v.getValue();

        if(usedValues.contains(value) && usedValues.length != v.words.length) continue;
        usedValues.add(value);

        phrase = phrase.replaceFirst("\$${v.keyword}\$", value);
      }
    }

    return phrase;
  }
}