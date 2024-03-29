import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/voice/guild_voice_manager.dart';


class BotVoiceManager {
  late final Map<Snowflake, GuildVoiceManager> _managers;

  BotVoiceManager(List<PartialGuild> guilds) {
    _managers = {};

    for(var guild in guilds) {
      _managers[guild.id] = GuildVoiceManager(guild);
    }

    Bot().client.onGuildCreate.listen((event) {
      _managers[event.guild.id] = GuildVoiceManager(event.guild);
    });
  }

  GuildVoiceManager operator[](Snowflake id) => _managers[id]!;
}