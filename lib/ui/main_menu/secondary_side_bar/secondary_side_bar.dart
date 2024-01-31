import 'package:flutter/material.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_menu_router.dart';
import 'package:umbrage_bot/ui/main_menu/secondary_side_bar/secondary_side_bar_button.dart';
import 'package:umbrage_bot/ui/main_menu/secondary_side_bar/secondary_side_bar_category.dart';

class SecondarySideBar extends StatefulWidget {
  static const double size = 190;

  const SecondarySideBar({super.key});

  @override
  State<SecondarySideBar> createState() => _SecondarySideBarState();
}

class _SecondarySideBarState extends State<SecondarySideBar> {

  void _onRouteChanged(bool b) {
    if(!b) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    
    MainMenuRouter().onRouteChanged(_onRouteChanged);
  }

  @override
  void dispose() {
    MainMenuRouter().removeListener(_onRouteChanged);

    super.dispose();
  }

  List<SecondarySideBarCategory> _createCategories() {
    List<SecondarySideBarCategory> categories = [];
    Map<String, List<MainWindow>> categoryWindows = {"": []}; // Empty category is always first!

    for(var window in MainMenuRouter().getActiveMainRoute().getWindows()) {
      if(!categoryWindows.containsKey(window.category)) categoryWindows[window.category] = [];

      categoryWindows[window.category]!.add(window);
    }

    for(var category in categoryWindows.keys) {
      categories.add(
        SecondarySideBarCategory(
          name: category,
          buttons: _createButtons(categoryWindows[category]!),
        )
      );
    }

    return categories;
  }

  List<SecondarySideBarButton> _createButtons(List<MainWindow> windows) {
    var buttons = <SecondarySideBarButton>[];

    for(var window in windows) {
      buttons.add(
        SecondarySideBarButton(
          name: window.name,
          icon: window.sideBarIcon,
          isActive: MainMenuRouter().getActiveWindow() == window,
          onTap: () {
            MainMenuRouter().subRouteTo(window.route);
          }
        )
      );
    }

    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    var categories = _createCategories();

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
                MainMenuRouter().getActiveMainRoute().name,
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