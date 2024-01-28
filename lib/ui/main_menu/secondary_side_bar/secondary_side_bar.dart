import 'package:flutter/material.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';
import 'package:umbrage_bot/ui/main_menu/main_sub_window.dart';
import 'package:umbrage_bot/ui/main_menu/secondary_side_bar/secondary_side_bar_button.dart';
import 'package:umbrage_bot/ui/main_menu/secondary_side_bar/secondary_side_bar_category.dart';

class SecondarySideBar extends StatefulWidget {
  static const double size = 190;
  final String name;
  final List<MainSubWindow> windows;
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

  void _validateCategories() {
    var windows = widget.windows;
    if(windows.isEmpty) return;

    var checkedCategories = <String>[windows[0].categoryName];

    for(int i = 1; i < windows.length; i++) {
      var c1 = windows[i-1].categoryName;
      var c2 = windows[i].categoryName;

      if(c1 != c2) {
        if(checkedCategories.contains(c2)) throw Exception("MainMenuSubWindows with the same category must be indexed consecutively");
        checkedCategories.add(c2);
      }
    }

    if(checkedCategories.indexOf("") > 0) throw Exception("MainMenuSubWindows with no category must be indexed before any other windows with a category");
  }

  void _createCategories() {
    var windows = widget.windows;
    var categories = <SecondarySideBarCategory>[];
    var lastIndex = 0;

    for(int i = 0; i < windows.length; i++) {
      var window = windows[i];
      
      if(i == windows.length-1 || window.categoryName != windows[i+1].categoryName) {
        categories.add(
          SecondarySideBarCategory(
            name: window.categoryName,
            buttons: _createButtons(lastIndex, i)
          )
        );
        lastIndex = i+1;
      }
    }

    this.categories = categories;
  }

  List<SecondarySideBarButton> _createButtons(int startIndex, int lastIndex) {
    var buttons = <SecondarySideBarButton>[];

    for(int i = startIndex; i <= lastIndex; i++) {
      var window = widget.windows[i];

      buttons.add(
        SecondarySideBarButton(
          name: window.name,
          icon: window.sideBarIcon,
          index: i,
          isActive: widget.activeButtonIndex == i,
          onTap: (index) {
            widget.onButtonTapped(i);
          }
        )
      );
    }

    return buttons;
  }

  @override
  void initState() {
    _validateCategories();
    super.initState();
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
          ...categories
        ],
      ),
    );
  }
}