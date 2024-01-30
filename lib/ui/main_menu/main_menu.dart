import 'package:flutter/material.dart';
import 'package:umbrage_bot/ui/main_menu/bot_profile/bot_profile_window.dart';
import 'package:umbrage_bot/ui/main_menu/lexicon/lexicon_window.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_menu_router.dart';
import 'package:umbrage_bot/ui/main_menu/secondary_side_bar/secondary_side_bar.dart';
import 'package:umbrage_bot/ui/main_menu/side_bar/side_bar.dart';
import 'package:umbrage_bot/ui/util/window_close_handler.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  //final MainMenuWindow timerWindow = MainMenuWindow("Timers", Symbols.timer); // TO-DO
  //final MainMenuWindow musicWindow = MainMenuWindow("Music", Symbols.music_note); // TO-DO
  //final MainMenuWindow settingsWindow = MainMenuWindow("Settings", Symbols.settings); // TO-DO

  void _onRouteChanged() {
    setState(() {
      
    });
  }

  @override
  void initState() {
    super.initState();

    var router = MainMenuRouter();
    router.addRoute(BotProfileWindow());
    router.addRoute(LexiconWindow());

    router.onRouteChanged(_onRouteChanged);

    WindowCloseHandler.init(context);
  }

  @override
  void dispose() {
    MainMenuRouter().removeListener(_onRouteChanged);

    super.dispose();
  }

  bool _shouldDrawSecondarySideBar() {
    return MainMenuRouter().getActiveMainRoute().getWindowCount() > 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                left: SideBar.size + (_shouldDrawSecondarySideBar() ? SecondarySideBar.size : 0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - SideBar.size - (_shouldDrawSecondarySideBar() ? SecondarySideBar.size : 0),
                  height: MediaQuery.of(context).size.height,
                  child: MainMenuRouter().getActiveWindow() ?? Container()
                )
              ),
              () {
                return !_shouldDrawSecondarySideBar() ? Container() : const Positioned(
                  left: SideBar.size,
                  child: SecondarySideBar(),
                );
              }(),
              const Positioned(
                left: 0,
                child: SideBar(),
              ),
            ],
          ),
        )
      ),
    );
  }
}