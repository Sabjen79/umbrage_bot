import 'package:flutter/material.dart';

class MainMenuSubWindow {
  final String name;
  final String categoryName;
  final Widget widget;

  MainMenuSubWindow({required this.name, required this.widget, this.categoryName = ""});
}