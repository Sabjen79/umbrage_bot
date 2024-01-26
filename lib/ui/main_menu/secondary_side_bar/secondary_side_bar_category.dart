import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';
import 'package:umbrage_bot/ui/main_menu/secondary_side_bar/secondary_side_bar.dart';
import 'package:umbrage_bot/ui/main_menu/secondary_side_bar/secondary_side_bar_button.dart';

class SecondarySideBarCategory extends StatefulWidget {
  final String name;
  final List<SecondarySideBarButton> buttons;

  const SecondarySideBarCategory(this.name, {
    required this.buttons,
    super.key
  });

  @override
  State<SecondarySideBarCategory> createState() => _SecondarySideBarCategoryState();
}

class _SecondarySideBarCategoryState extends State<SecondarySideBarCategory> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        width: SecondarySideBar.size,
        child: Padding(
          padding: const EdgeInsets.only(top: 5, left: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Positioned(
                      left: 0,
                      child: Icon(
                        Symbols.keyboard_arrow_down,
                        size: 10,
                        opticalSize: 20,
                        grade: 200,
                        weight: 200,
                        color: DiscordTheme.lightGray,
                      ),
                    ),
                    Positioned(
                      left: 10,
                      top: -0.5,
                      child: Text(
                        widget.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: DiscordTheme.lightGray,
                          fontSize: 10,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ...widget.buttons
            ],
          ),
        ),
      )
    );
  }
}