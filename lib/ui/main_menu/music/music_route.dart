import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';
import 'package:umbrage_bot/ui/main_menu/music/guild_window/music_guild_window.dart';
import 'package:umbrage_bot/ui/main_menu/music/music_help_window.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_route.dart';

class MusicRoute extends MainRoute {
  MusicRoute() : super("music", "Music", Symbols.music_note);

  @override
  List<MainWindow> defineWindows() {
    var list  = <MainWindow>[];

    list.add(const MusicHelpWindow());

    for(var guild in Bot().guildList) {
      final window = MusicGuildWindow(guild);
      list.add(window);

      if(defaultRoute.isEmpty) defaultRoute = window.route;
    }

    return list;
  }

}