import 'package:flutter/material.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';
import 'package:umbrage_bot/ui/main_menu/main_sub_window.dart';
import 'package:umbrage_bot/ui/main_menu/main_sub_window_list.dart';
import 'package:umbrage_bot/ui/main_menu/secondary_side_bar/secondary_side_bar_button.dart';
import 'package:umbrage_bot/ui/main_menu/secondary_side_bar/secondary_side_bar_category.dart';

class SecondarySideBar extends StatefulWidget {
  static const double size = 190;
  final String name;
  final MainSubWindowList windows;
  final int activeButtonIndex;
  final Function(int) onButtonTapped;

  const SecondarySideBar({
    required this.name,
    required this.windows,
    required this.onButtonTapped,
    this.activeButtonIndex = 0,
    super.key
  });

  @override
  State<SecondarySideBar> createState() => _SecondarySideBarState();
}

class _SecondarySideBarState extends State<SecondarySideBar> {
  List<SecondarySideBarCategory> categories = [];
  int _buttonsIndex = 0;

  void _createCategories() {
    var categories = <SecondarySideBarCategory>[];
    _buttonsIndex = 0;

    for(var category in widget.windows.getMap().keys) {
      categories.add(
        SecondarySideBarCategory(
          name: category,
          buttons: _createButtons(widget.windows.getMap()[category] ?? []),
        )
      );
    }

    this.categories = categories;
  }

  List<SecondarySideBarButton> _createButtons(List<MainSubWindow> windows) {
    var buttons = <SecondarySideBarButton>[];

    for(var window in windows) {
      buttons.add(
        SecondarySideBarButton(
          name: window.name,
          icon: window.sideBarIcon,
          index: _buttonsIndex,
          isActive: widget.activeButtonIndex == _buttonsIndex,
          onTap: (index) {
            widget.onButtonTapped(index);
          }
        )
      );

      _buttonsIndex++;
    }

    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    _createCategories();

    return Container(
      width: SecondarySideBar.size,
      height: MediaQuery.of(context).size.height,
      color: DiscordTheme.backgroundColorDark,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            width: SecondarySideBar.size,
            height: 40,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(
                widget.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
          ),
          Container(
            width: SecondarySideBar.size,
            height: 1,
            decoration: const BoxDecoration(
              color: DiscordTheme.backgroundColorDarkest,
              boxShadow: [
                BoxShadow(
                  color: Color(0x30303030),
                  blurRadius: 4,
                  spreadRadius: 1
                )
              ]
            ),
          ),
          Expanded(
            child: ListView(
              children: categories,
            )
          )
        ],
      ),
    );
  }
}