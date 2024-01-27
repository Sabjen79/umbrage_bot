import 'package:flutter/material.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';
import 'package:umbrage_bot/ui/main_menu/secondary_side_bar/secondary_side_bar_category.dart';

class SecondarySideBar extends StatefulWidget {
  static const double size = 190;
  final String name;
  final List<SecondarySideBarCategory> categories;
  final int activeButtonIndex;

  const SecondarySideBar({
    required this.name, 
    this.categories = const [],
    this.activeButtonIndex = 0,
    super.key
  });

  @override
  State<SecondarySideBar> createState() => _SecondarySideBarState();
}

class _SecondarySideBarState extends State<SecondarySideBar> {

  @override
  Widget build(BuildContext context) {
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
          ...widget.categories
        ],
      ),
    );
  }
}