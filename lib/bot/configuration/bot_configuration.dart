import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/util/bot_files/bot_files.dart';
import 'package:umbrage_bot/bot/util/json_serializable.dart';

class BotConfiguration with JsonSerializable {
  final String botId;
  int typingSpeed = 30;
  int reactionSpeedMin = 1000;
  int reactionSpeedMax = 1500;

  BotConfiguration(Bot bot) : botId = bot.user.id.toString() {
    var json = loadFromJson();

    if(json == null) return;
  }

  @override
  String get jsonFilepath => "${BotFiles().getMainDir().path}/config.json";

  @override
  Map<String, dynamic> toJson() => {

  };
}