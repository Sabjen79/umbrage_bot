import 'package:material_symbols_icons/symbols.dart';
import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/ui/main_menu/music/guild_window/music_guild_window.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_route.dart';

class MusicWindow extends MainRoute {
  MusicWindow(List<Guild> guilds) : super("music", "Music", Symbols.music_note) {
    for(var guild in guilds) {
      addWindow(MusicGuildWindow(guild));
    }
  }
}