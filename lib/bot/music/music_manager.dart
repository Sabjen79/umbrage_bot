import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/music/guild_music_manager.dart';

class MusicManager {
  late final Map<Snowflake, GuildMusicManager> _managers;

  MusicManager(List<PartialGuild> guilds) {
    _managers = {};

    for(var guild in guilds) {
      _managers[guild.id] = GuildMusicManager(guild);
    }
  }

  GuildMusicManager operator[](Snowflake id) => _managers[id]!;
}