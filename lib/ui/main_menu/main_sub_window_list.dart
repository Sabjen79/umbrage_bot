import 'package:flutter/material.dart';
import 'package:umbrage_bot/ui/main_menu/main_sub_window.dart';

class MainSubWindowList with ChangeNotifier {
  final List<MainSubWindow> _list = [];

  List<MainSubWindow> getList() {
    return _list;
  }

  void add(MainSubWindow window) { // TO-DO: better add function, remove category parameter and subtitute here
    _list.add(window);

    notifyListeners();
  }

  void clear() {
    _list.clear();
  }
}