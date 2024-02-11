import 'package:umbrage_bot/bot/util/bot_files.dart';
import 'package:umbrage_bot/bot/util/json_serializable.dart';

class BotGuildConfiguration with JsonSerializable {
  final String guildId;
  int musicChannelId = 0;
  bool restrictMusicChannel = true;
  String restrictMusicChannelMessage = "You can only queue music here!";

  BotGuildConfiguration(this.guildId) {
    reset();
  }

  void reset() {
    var json = loadFromJson();

    musicChannelId = (json['musicChannelId'] ?? 0) as int;
    restrictMusicChannel = (json['restrictMusicChannel'] ?? true) as bool;
    restrictMusicChannelMessage = (json['restrictMusicChannelMessage'] ?? "You can only queue music here!") as String;
  }

  @override
  Map<String, dynamic> toJson() => {
    'musicChannelId': musicChannelId,
    'restrictMusicChannel': restrictMusicChannel,
    'restrictMusicChannelMessage': restrictMusicChannelMessage
  };

  @override
  String get jsonFilepath => "${BotFiles().getMainDir().path}/guilds/$guildId/config.json";
}