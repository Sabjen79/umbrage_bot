import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

abstract class MainWindow extends StatefulWidget {
  final String route;
  final String category;
  final String name;
  final IconData sideBarIcon;

  const MainWindow({required this.route, required this.name, this.category = "", this.sideBarIcon = Symbols.tag, super.key});
}

// Here lies the grave of EmptyMainSubWindow, which was deleted because it was no longer needed :(