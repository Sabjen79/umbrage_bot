import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';
import 'package:umbrage_bot/ui/main_menu/side_bar/side_bar_button.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  int _activeIndex = -1;

  void setActiveButton(int index) {
    setState(() {
      _activeIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DiscordTheme.backgroundColorDarkest,
      width: 60,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SideBarButton(
              label: Bot().user.username,
              onTap: () { setActiveButton(0); },
              isActive: _activeIndex == 0,
              child: Image.network(Bot().user.avatar.url.toString()),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Container(
                height: 1.5,
                width: 30,
                color: DiscordTheme.backgroundColorDark,
              ),
            ),
            SideBarButton(
              label: "Timers",
              icon: Symbols.timer,
              onTap: () { setActiveButton(1); },
              isActive: _activeIndex == 1
            ),
            SideBarButton(
              label: "Music",
              icon: Symbols.music_note,
              onTap: () { setActiveButton(2); },
              isActive: _activeIndex == 2
            ),
            SideBarButton(
              label: "Lexicon",
              icon: Symbols.quick_phrases,
              onTap: () { setActiveButton(3); },
              isActive: _activeIndex == 3
            ),
            SideBarButton(
              label: "Settings",
              icon: Symbols.settings,
              onTap: () { setActiveButton(4); },
              isActive: _activeIndex == 4
            ),
          ],
        ),
      )
    );
  }
}