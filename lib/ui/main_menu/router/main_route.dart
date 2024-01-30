import 'package:flutter/material.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';

abstract class MainRoute {
  final String routeName;
  final String name;
  final IconData? icon;
  final Map<String, MainWindow> _windows = {}; // key is route name
  String _activeSubRoute = "";

  MainRoute(this.routeName, this.name, this.icon);

  MainWindow? getActiveWindow() => _windows[_activeSubRoute];
  String getActiveRoute() => _activeSubRoute;
  int getWindowCount() => _windows.length;
  List<MainWindow> getWindows() => _windows.values.toList();

  void addWindow(MainWindow w) {
    _windows[w.route] = w;

    if(_activeSubRoute.isEmpty) _activeSubRoute = w.route;
  }

  void routeTo(String route) {
    if(!_windows.containsKey(route)) throw Exception("Subroute doesn't exist: $route");

    _activeSubRoute = route;
  }

  void clearWindows() { _windows.clear(); }
}