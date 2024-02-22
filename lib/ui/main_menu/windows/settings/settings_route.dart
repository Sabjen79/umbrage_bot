import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_route.dart';
import 'package:umbrage_bot/ui/main_menu/windows/settings/global_settings/conversation_settings_window.dart';
import 'package:umbrage_bot/ui/main_menu/windows/settings/global_settings/music_settings_window.dart';
import 'package:umbrage_bot/ui/main_menu/windows/settings/guild_settings/guild_settings_window.dart';

class SettingsRoute extends MainRoute {
  SettingsRoute() : super("settings", "Settings", Symbols.settings);

  @override
  List<MainWindow> defineWindows() {
    var list  = <MainWindow>[];

    list.add(const MusicSettingsWindow());
    list.add(const ConversationSettingsWindow());

    for(var guild in Bot().guildList) {
      list.add(GuildSettingsWindow(guild));
    }

    return list;
  }
}