import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/ui/main_menu/extensions/mute_kick_window.dart';
import 'package:umbrage_bot/ui/main_menu/extensions/profile_picture/profile_picture_window.dart';
import 'package:umbrage_bot/ui/main_menu/extensions/random_music_window.dart';
import 'package:umbrage_bot/ui/main_menu/extensions/volume_booster_window.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_route.dart';

class ExtensionsRoute extends MainRoute {
  ExtensionsRoute() : super("extensions", "Extensions", Symbols.mindfulness);

  @override
  List<MainWindow> defineWindows() {
    var list  = <MainWindow>[];

    list.addAll(const [
      ProfilePictureWindow(),
      MuteKickWindow(),
      RandomMusicWindow(),
      VolumeBoosterWindow()
    ]);

    return list;
  }
}