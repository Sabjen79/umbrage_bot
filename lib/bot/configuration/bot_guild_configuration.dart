import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/util/bot_files.dart';
import 'package:umbrage_bot/bot/util/json_serializable.dart';

class BotGuildConfiguration with JsonSerializable {
  final String guildId;
  late int mainMessageChannelId = 0;
  late int musicChannelId = 0;

  Future<Channel> get mainMessageChannel async {
    return await Bot().client.channels.get(Snowflake(mainMessageChannelId));
  }


  BotGuildConfiguration(this.guildId) {
    reset();
  }

  Future<int> _defaultMainMessageChannel() async {
    final guild = await Bot().client.guilds[Snowflake(int.parse(guildId))].get();
    if(guild.systemChannel != null) return guild.systemChannel!.id.value;

    for(final channel in await guild.fetchChannels()) {
      if(channel is TextChannel && channel is! VoiceChannel) {
        return channel.id.value;
      }
    }

    throw Exception("Guild has no text channels.");
  }

  void reset() async {
    var json = loadFromJson();

    musicChannelId = (json['musicChannelId'] ?? 0) as int;
    mainMessageChannelId = (json['mainMessageChannelId'] ?? await _defaultMainMessageChannel()) as int;
  }

  @override
  Map<String, dynamic> toJson() => {
    'mainMessageChannelId': mainMessageChannelId,
    'musicChannelId': musicChannelId,
  };

  @override
  String get jsonFilepath => "${BotFiles().getMainDir().path}/guilds/$guildId/config.json";
}