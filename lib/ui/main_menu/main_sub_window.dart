import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class MainSubWindow {
  final String name;
  final String categoryName;
  final IconData sideBarIcon;
  final Widget widget;

  MainSubWindow({required this.name, required this.widget, this.categoryName = "", this.sideBarIcon = Symbols.tag});
}