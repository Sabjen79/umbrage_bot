import 'package:flutter/material.dart';
import 'package:umbrage_bot/ui/main_menu/secondary_side_bar/secondary_side_bar.dart';
import 'package:umbrage_bot/ui/main_menu/secondary_side_bar/secondary_side_bar_button.dart';
import 'package:umbrage_bot/ui/main_menu/secondary_side_bar/secondary_side_bar_category.dart';
import 'package:umbrage_bot/ui/main_menu/side_bar/side_bar.dart';
import 'package:umbrage_bot/ui/main_menu/main_menu_sub_window.dart';

abstract class MainMenuWindow extends StatefulWidget {
  final String _name;
  final IconData? _icon;
  final List<MainMenuSubWindow> _windows;
  
  const MainMenuWindow(this._name, this._icon, this._windows, {required super.key});

  String getName() {
    return _name;
  }

  IconData? getIcon() {
    return _icon;
  }

  List<MainMenuSubWindow> getWindows() {
    return _windows;
  }

  @override
  State<MainMenuWindow> createState() => _MainMenuWindowState();
}

class _MainMenuWindowState extends State<MainMenuWindow> {
  int _activeButtonIndex = 0;

  void _validateCategories() {
    var windows = widget.getWindows();
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

  @override
  void initState() {
    _validateCategories();
    super.initState();
  }

  List<SecondarySideBarCategory> _createCategories() {
    var windows = widget.getWindows();
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

    return categories;
  }

  List<SecondarySideBarButton> _createButtons(int startIndex, int lastIndex) {
    var buttons = <SecondarySideBarButton>[];

    for(int i = startIndex; i <= lastIndex; i++) {
      var window = widget.getWindows()[i];

      buttons.add(
        SecondarySideBarButton(
          name: window.name,
          index: i,
          isActive: _activeButtonIndex == i,
          onTap: (index) {
            setState(() {
              _activeButtonIndex = i;
            });
          }
        )
      );
    }

    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    var categories = _createCategories();
    var windows = widget.getWindows();

    return SizedBox(
      width: MediaQuery.of(context).size.width - SideBar.size,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          () {
            if(windows.length < 2) return Container();

            return Positioned(
              left: 0,
              child: SecondarySideBar(
                name: widget.getName(),
                categories: categories,
                activeButtonIndex: _activeButtonIndex
              ),
            );
          }(),
          windows[_activeButtonIndex].widget
        ],
      )
    );
  }
}