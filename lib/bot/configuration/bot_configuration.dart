import 'dart:math';

import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/configuration/bot_guild_configuration.dart';
import 'package:umbrage_bot/bot/util/bot_files/bot_files.dart';
import 'package:umbrage_bot/bot/util/json_serializable.dart';

class BotConfiguration with JsonSerializable {
  final Map<String, BotGuildConfiguration> _guilds = {};
  late int typingSpeed;
  late int reactionSpeedMin;
  late int reactionSpeedMax;
  int get randomReactionSpeed => reactionSpeedMin == reactionSpeedMax ? reactionSpeedMin : reactionSpeedMin + Random().nextInt(reactionSpeedMax - reactionSpeedMin);

  BotConfiguration(List<PartialGuild> guilds) {
    for(var g in guilds) {
      _guilds[g.id.toString()] = BotGuildConfiguration(g.id.toString());
    }

    reset();
  }

  void reset() {
    var json = loadFromJson();

    typingSpeed = (json['typingSpeed'] ?? 30) as int;
    reactionSpeedMin = (json['reactionSpeedMin'] ?? 1000) as int;
    reactionSpeedMax = (json['reactionSpeedMax'] ?? 1500) as int;
  }

  @override
  Map<String, dynamic> toJson() => {
    'typingSpeed': typingSpeed,
    'reactionSpeedMin': reactionSpeedMin,
    'reactionSpeedMax': reactionSpeedMax
  };

  @override
  String get jsonFilepath => "${BotFiles().getMainDir().path}/config.json";

  BotGuildConfiguration operator[](Snowflake id) {
    if(_guilds[id.toString()] == null) throw Exception("There is no guild with that id");

    return _guilds[id.toString()]!;
  }
}