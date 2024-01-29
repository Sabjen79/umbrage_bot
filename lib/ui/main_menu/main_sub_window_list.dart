import 'package:flutter/material.dart';
import 'package:umbrage_bot/ui/main_menu/main_sub_window.dart';

class MainSubWindowList with ChangeNotifier {
  final Map<String, List<MainSubWindow>> _windows = <String, List<MainSubWindow>>{"": []};
  int _length = 0;

  int getLength() => _length;

  Map<String, List<MainSubWindow>> getMap() {
    return _windows;
  }

  List<MainSubWindow> getList() {
    List<MainSubWindow> list = [];

    for(var value in _windows.values) {
      list.addAll(value);
    }

    return list;
  }

  void add(MainSubWindow window, [String category = ""]) {
    if(!_windows.containsKey(category)) _windows[category] = [];

    _windows[category]!.add(window);
    _length++;

    notifyListeners();
  }

  void delete(MainSubWindow window) {
    // TO-DO: You might not need this, but you ought to implement it.
    throw UnimplementedError();
  }

  void clear() {
    _windows.clear();
    _length = 0;

    _windows[""] = []; // The empty category should always be the first!
  }
}