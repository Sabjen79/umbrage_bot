import 'package:flutter/material.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_route.dart';

class MainMenuRouter {
  // Singleton
  static final MainMenuRouter _instance = MainMenuRouter._init();

  factory MainMenuRouter() {
    return _instance;
  }
    
  MainMenuRouter._init() {
    _routes = <String, MainRoute>{};
  }
  //

  late final Map<String, MainRoute> _routes;
  String _activeRoute = "";
  final List<VoidCallback> _listeners = [];

  List<MainRoute> getMainRoutes() => _routes.values.toList();
  MainRoute getActiveMainRoute() => _routes[_activeRoute]!;
  MainWindow? getActiveWindow() => _routes[_activeRoute]?.getActiveWindow();

  void addRoute(MainRoute r) {
    _routes[r.routeName] = r;

    if(_activeRoute.isEmpty) _activeRoute = r.routeName;

    for(var l in _listeners) {
      l();
    }
  }

  void routeTo(String route) {
    var split = route.split(RegExp(r'[\\/]+'));
    if(split.length > 2 || split.isEmpty) throw Exception("Invalid route: $route");

    if(_routes[split[0]] == null) throw Exception("Non-existent route: $route");
    _activeRoute = split[0];

    if(split.length == 2) {
      _routes[_activeRoute]!.routeTo(split[1]);
    }

    for(var l in _listeners) {
      l();
    }
  }

  void subRouteTo(String route) {
    routeTo("$_activeRoute/$route");
  }

  void onRouteChanged(VoidCallback v) {
    _listeners.add(v);
  }

  void removeListener(VoidCallback v) {
    _listeners.remove(v);
  }
}