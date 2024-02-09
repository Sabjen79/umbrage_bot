import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_route.dart';
import 'package:umbrage_bot/ui/main_menu/settings/global_settings/conversation_settings_window.dart';
import 'package:umbrage_bot/ui/main_menu/settings/guild_settings/guild_settings_window.dart';

class SettingsWindow extends MainRoute {
  SettingsWindow() : super("settings", "Settings", Symbols.settings);

  Future<void> initWindows() async {
    addWindow(ConversationSettingsWindow());

    for(var guild in await Bot().client.listGuilds()) {
      addWindow(GuildSettingsWindow(await guild.get()));
    }
  }
}