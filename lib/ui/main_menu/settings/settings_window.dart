import 'package:material_symbols_icons/symbols.dart';
import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_route.dart';
import 'package:umbrage_bot/ui/main_menu/settings/global_settings/conversation_settings_window.dart';
import 'package:umbrage_bot/ui/main_menu/settings/global_settings/music_settings_window.dart';
import 'package:umbrage_bot/ui/main_menu/settings/guild_settings/guild_settings_window.dart';

class SettingsWindow extends MainRoute {
  SettingsWindow(List<Guild> guilds) : super("settings", "Settings", Symbols.settings) {
    
    addWindow(const MusicSettingsWindow());
    addWindow(const ConversationSettingsWindow());

    for(var guild in guilds) {
      addWindow(GuildSettingsWindow(guild));
    }
  }
}