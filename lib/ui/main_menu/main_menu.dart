import 'package:flutter/material.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_menu_router.dart';
import 'package:umbrage_bot/ui/main_menu/secondary_side_bar/secondary_side_bar.dart';
import 'package:umbrage_bot/ui/main_menu/side_bar/side_bar.dart';
import 'package:umbrage_bot/ui/util/window_close_handler.dart';

class MainMenu extends StatefulWidget {
  static double getMainWindowWidth(BuildContext context) {
    return MediaQuery.of(context).size.width - 
            SideBar.size - 
            (MainMenuRouter().getActiveMainRoute().getWindowCount() > 1 ? SecondarySideBar.size : 0);
  }

  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  //final MainMenuWindow timerWindow = MainMenuWindow("Timers", Symbols.timer); // TO-DO
  //final MainMenuWindow musicWindow = MainMenuWindow("Music", Symbols.music_note); // TO-DO

  @override
  void initState() {
    super.initState();

    MainMenuRouter().onRouteChanged(_onRouteChanged);

    WindowCloseHandler.init(context);
  }

  @override
  void dispose() {
    MainMenuRouter().removeListener(_onRouteChanged);

    super.dispose();
  }

  void _onRouteChanged(bool b) {
    if(!b) setState(() {});
  }

  bool _shouldDrawSecondarySideBar() {
    return MainMenuRouter().getActiveMainRoute().getWindowCount() > 1;
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
                left: SideBar.size + (_shouldDrawSecondarySideBar() ? SecondarySideBar.size : 0),
                child: SizedBox(
                  width: MainMenu.getMainWindowWidth(context),
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: double.maxFinite,
                        height: double.maxFinite,
                        child: MainMenuRouter().getActiveWindow() ?? Container(),
                      ),
                      
                      Positioned(
                        bottom: 10,
                        child: MainMenuRouter().getSaveChangesSnackbar() ?? Container()
                      ) 
                    ],
                  ),
                ),
              ),

              Positioned(
                left: SideBar.size,
                child: _shouldDrawSecondarySideBar() ? const SecondarySideBar() : const SizedBox(),
              ),

              const Positioned(
                left: 0,
                child: SideBar()
              ),
            ],
          ),
        )
      ),
    );
  }
}