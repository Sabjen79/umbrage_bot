import 'package:flutter/foundation.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_route.dart';
import 'package:umbrage_bot/ui/main_menu/router/save_changes_snackbar.dart';

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

  final List<Function(bool)> _listeners = [];

  final SaveChangesSnackbar _snackBar = const SaveChangesSnackbar();

  Function(bool, AsyncCallback?, AsyncCallback?)? blockListener;

  String _activeRoute = "";

  bool _blocked = false;


  SaveChangesSnackbar? getSaveChangesSnackbar() => _snackBar;
  List<MainRoute> getMainRoutes() => _routes.values.toList();
  MainRoute getActiveMainRoute() => _routes[_activeRoute]!;
  MainWindow? getActiveWindow() => _routes[_activeRoute]?.getActiveWindow();


  void addRoute(MainRoute r) {
    _routes[r.routeName] = r;

    if(_activeRoute.isEmpty) _activeRoute = r.routeName;

    for(var l in _listeners) {
      l(true);
    }
  }

  void block(AsyncCallback resetAction, AsyncCallback saveAction) {
    _blocked = true;

    blockListener?.call(true, resetAction, saveAction);
  }

  void unblock() {
    _blocked = false;

    blockListener?.call(false, null, null);
  }

  void routeTo(String route) {
    if(!_blocked) {
      var split = route.split(RegExp(r'[\\/]+'));
      if(split.length > 2 || split.isEmpty) throw Exception("Invalid route: $route");

      if(_routes[split[0]] == null) throw Exception("Non-existent route: $route");
      _activeRoute = split[0];

      if(split.length == 2) {
        _routes[_activeRoute]!.routeTo(split[1]);
      }
    }

    for(var l in _listeners) {
      l(_blocked);
    }
  }

  void subRouteTo(String route) {
    routeTo("$_activeRoute/$route");
  }

  void onRouteChanged(Function(bool) v) {
    _listeners.add(v);
  }

  void removeListener(Function(bool) v) {
    _listeners.remove(v);
  }
}