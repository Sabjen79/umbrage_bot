import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/util/bot_files.dart';
import 'package:umbrage_bot/bot/util/json_serializable.dart';

class BotGuildConfiguration with JsonSerializable {
  final String guildId;
  late int mainMessageChannelId = 0;
  late int musicChannelId = 0;
  late int defaultVoiceChannelId = 0;

  Future<Channel> get mainMessageChannel async {
    return await Bot().client.channels.get(Snowflake(mainMessageChannelId));
  }

  Future<Channel> get defaultVoiceChannel async {
    return await Bot().client.channels.get(Snowflake(defaultVoiceChannelId));
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

  Future<int> _defaultVoiceChannel() async {
    final guild = Bot().client.guilds[Snowflake(int.parse(guildId))];

    for(final channel in await guild.fetchChannels()) {
      if(channel is VoiceChannel) {
        return channel.id.value;
      }
    }

    throw Exception("Guild has no voice channels.");
  }

  void reset() async {
    var json = loadFromJson();

    mainMessageChannelId = (json['mainMessageChannelId'] ?? await _defaultMainMessageChannel()) as int;
    musicChannelId = (json['musicChannelId'] ?? 0) as int;
    defaultVoiceChannelId = (json['defaultVoiceChannelId'] ?? await _defaultVoiceChannel()) as int;
  }

  @override
  Map<String, dynamic> toJson() => {
    'mainMessageChannelId': mainMessageChannelId,
    'musicChannelId': musicChannelId,
    'defaultVoiceChannelId': defaultVoiceChannelId
  };

  @override
  String get jsonFilepath => "${BotFiles().getDirForGuild(guildId).path}/config.json";
}