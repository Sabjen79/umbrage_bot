import 'package:umbrage_bot/bot/util/bot_files/bot_files.dart';
import 'package:umbrage_bot/bot/util/json_serializable.dart';

class BotGuildConfiguration with JsonSerializable {
  final String guildId;
  int musicChannelId = 0;
  bool restrictMusicChannel = true;

  BotGuildConfiguration(this.guildId) {
    reset();
  }

  void reset() {
    var json = loadFromJson();

    musicChannelId = (json['musicChannelId'] ?? 0) as int;
    restrictMusicChannel = (json['restrictMusicChannel'] ?? true) as bool;
  }

  @override
  Map<String, dynamic> toJson() => {
    'musicChannelId': musicChannelId,
    'restrictMusicChannel': restrictMusicChannel
  };

  @override
  String get jsonFilepath => "${BotFiles().getMainDir().path}/guilds/$guildId/config.json";
}