import 'package:flutter/material.dart';
import 'package:umbrage_bot/ui/main_menu/bot_profile/bot_profile_window.dart';
import 'package:umbrage_bot/ui/main_menu/lexicon/lexicon_window.dart';
import 'package:umbrage_bot/ui/main_menu/main_menu_window.dart';
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

  final List<MainMenuWindow> _windows = [];
  int _sideBarIndex = 0;

  @override
  void initState() {
    super.initState();

    _windows.addAll([
      BotProfileWindow(),
      LexiconWindow()
    ]);

    WindowCloseHandler.init(context);
  }

  void _sideBarButtonPressed(int newIndex) {
    setState(() {
      _sideBarIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    var activeWindow = _windows[_sideBarIndex];

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                left: SideBar.size,
                child: activeWindow,
              ),
              Positioned(
                left: 0,
                child: SideBar(
                  windows: _windows,
                  onButtonPressed: _sideBarButtonPressed
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}