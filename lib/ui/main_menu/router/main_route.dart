import 'package:flutter/material.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';

abstract class MainRoute {
  final String routeName;
  final String name;
  final IconData? icon;
  final bool showSidebar;
  final Map<String, MainWindow> _windows = {}; // key is route name
  String _activeSubRoute = "";
  String defaultRoute = "";

  MainRoute(this.routeName, this.name, this.icon, [this.showSidebar = true]) {
    Bot().client.onGuildCreate.listen((event) async {
      await Bot().refreshGuildList();
      refreshWindows();
    });
  }

  MainWindow? getActiveWindow() => _windows[_activeSubRoute];
  String getActiveRoute() => _activeSubRoute;
  int getWindowCount() => _windows.length;
  List<MainWindow> getWindows() => _windows.values.toList();

  List<MainWindow> defineWindows();

  void refreshWindows() {
    final windows = defineWindows();
    _windows.clear();
    for(final window in windows) {
      _windows[window.route] = window;

      if(_activeSubRoute.isEmpty) _activeSubRoute = window.route;
    }

    if(defaultRoute.isNotEmpty) _activeSubRoute = defaultRoute;
  }

  void routeTo(String route) {
    if(!_windows.containsKey(route)) throw Exception("Subroute doesn't exist: $route");

    _activeSubRoute = route;
  }

  void clearWindows() { _windows.clear(); }
}