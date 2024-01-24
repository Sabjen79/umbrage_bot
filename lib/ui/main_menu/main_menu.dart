import 'package:flutter/material.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';
import 'package:umbrage_bot/ui/main_menu/side_bar/side_bar.dart';
import 'package:umbrage_bot/ui/util/window_close_handler.dart';

class MainMenu extends StatefulWidget {

  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();

    WindowCloseHandler.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: const Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                left: 0,
                child: SideBar(),
              ),
            ],
          ),
        )
      ),
    );
  }
}