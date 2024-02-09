import 'dart:math';

import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/util/bot_files/bot_files.dart';
import 'package:umbrage_bot/bot/util/json_serializable.dart';

class BotConfiguration with JsonSerializable {
  final String botId;
  int typingSpeed = 30;
  int reactionSpeedMin = 1000;
  int reactionSpeedMax = 1500;
  int get randomReactionSpeed => reactionSpeedMin == reactionSpeedMax ? reactionSpeedMin : reactionSpeedMin + Random().nextInt(reactionSpeedMax - reactionSpeedMin);

  BotConfiguration(Bot bot) : botId = bot.user.id.toString() {
    reset();
  }

  void reset() {
    var json = loadFromJson();

    if(json == null) return;

    typingSpeed = json['typingSpeed'] as int;
    reactionSpeedMin = json['reactionSpeedMin'] as int;
    reactionSpeedMax = json['reactionSpeedMax'] as int;
  }

  @override
  String get jsonFilepath => "${BotFiles().getMainDir().path}/config.json";

  @override
  Map<String, dynamic> toJson() => {
    'typingSpeed': typingSpeed,
    'reactionSpeedMin': reactionSpeedMin,
    'reactionSpeedMax': reactionSpeedMax
  };
}