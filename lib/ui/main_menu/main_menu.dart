import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/ui/main_menu/lexicon/lexicon_menu.dart';
import 'package:umbrage_bot/ui/main_menu/main_menu_window.dart';
import 'package:umbrage_bot/ui/main_menu/side_bar/secondary_side_bar.dart';
import 'package:umbrage_bot/ui/main_menu/side_bar/side_bar.dart';
import 'package:umbrage_bot/ui/util/window_close_handler.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  final MainMenuWindow profileWindow = MainMenuWindow(Bot().user.username, null);
  final MainMenuWindow timerWindow = MainMenuWindow("Timers", Symbols.timer);
  final MainMenuWindow musicWindow = MainMenuWindow("Music", Symbols.music_note);
  final MainMenuWindow lexiconWindow = MainMenuWindow("Lexicon", Symbols.quick_phrases);
  final MainMenuWindow settingsWindow = MainMenuWindow("Settings", Symbols.settings);

  final List<MainMenuWindow> windows = [];
  int _sideBarIndex = 0;

  @override
  void initState() {
    super.initState();

    windows.addAll([profileWindow, timerWindow, musicWindow, lexiconWindow, settingsWindow]);

    WindowCloseHandler.init(context);
  }

  void _sideBarButtonPressed(int newIndex) {
    setState(() {
      _sideBarIndex = newIndex;
    });
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
                left: SideBar.size + SecondarySideBar.size,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - (SideBar.size + SecondarySideBar.size),
                  height: MediaQuery.of(context).size.height,
                  child: <Widget>[
                    const Text("Welcome!"),
                    const Text("TIMERS"),
                    const Text("Musick"),
                    const LexiconMenu(),
                    const Text("Settings")
                  ][_sideBarIndex],
                ),
              ),
              Positioned(
                left: SideBar.size,
                child: SecondarySideBar(windows[_sideBarIndex]),
              ),
              Positioned(
                left: 0,
                child: SideBar(
                  windows: windows,
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