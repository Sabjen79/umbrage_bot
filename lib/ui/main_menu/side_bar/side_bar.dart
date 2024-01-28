import 'package:flutter/material.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';
import 'package:umbrage_bot/ui/main_menu/side_bar/side_bar_button.dart';

class SideBar extends StatefulWidget {
  static const double size = 60;

  final Function(int) onButtonPressed;
  final List<MainWindow> windows;

  const SideBar({required this.windows, required this.onButtonPressed, super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  int _activeIndex = 0;

  void setActiveButton(int index) {
    setState(() {
      _activeIndex = index;
      widget.onButtonPressed(index);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _sideBarButton(int index) {
    var window = widget.windows[index];

    return SideBarButton(
      label: window.getName(),
      icon: window.getIcon(),
      onTap: () { setActiveButton(index); },
      isActive: _activeIndex == index,
      child: window.getIcon() == null ? Image.network(Bot().user.avatar.url.toString()) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DiscordTheme.backgroundColorDarkest,
      width: SideBar.size,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _sideBarButton(0),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Container(
                height: 1.5,
                width: 30,
                color: DiscordTheme.backgroundColorDark,
              ),
            ),
            ...() {
              var widgets = [];

              for(int i = 1; i < widget.windows.length; i++) {
                widgets.add(_sideBarButton(i));
              }

              return widgets;
            }()
          ],
        ),
      )
    );
  }
}