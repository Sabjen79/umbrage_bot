import 'dart:async';

import 'package:flutter/material.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_menu_router.dart';
import 'package:umbrage_bot/ui/main_menu/side_bar/side_bar_button.dart';

class SideBar extends StatefulWidget {
  static const double size = 60;

  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  late StreamSubscription _streamSubscription;

  void _onRouteChanged(bool b) {
    if(!b) setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _streamSubscription = Bot().eventHandler.onBotUserUpdate.listen((e) {
      setState(() {});
    });
    
    MainMenuRouter().onRouteChanged(_onRouteChanged);
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    MainMenuRouter().removeListener(_onRouteChanged);

    super.dispose();
  }

  Widget _createButton(int index) {
    var route = MainMenuRouter().getMainRoutes()[index];

    return SideBarButton(
      label: route.name,
      icon: route.icon,
      isActive: route == MainMenuRouter().getActiveMainRoute(),
      onTap: () { MainMenuRouter().routeTo(route.routeName); },
      child: route.icon == null ? Image.network(Bot().user.avatar.url.toString()) : null,
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
            _createButton(0),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Container(
                height: 1.5,
                width: 30,
                color: DiscordTheme.backgroundColorDark,
              ),
            ),
            ...() {
              var routes = MainMenuRouter().getMainRoutes();
              var widgets = [];

              for(int i = 1; i < routes.length; i++) {
                widgets.add(_createButton(i));
              }

              return widgets;
            }()
          ],
        ),
      )
    );
  }
}