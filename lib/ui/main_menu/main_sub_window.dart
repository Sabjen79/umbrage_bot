import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

abstract class MainSubWindow extends StatefulWidget {
  final String name;
  final IconData sideBarIcon;

  MainSubWindow({required this.name, this.sideBarIcon = Symbols.tag, super.key});
}
// Don't use the below class unless you need unimplemented windows for testing, 
// an empty widget should be stateless, but for convenience it is sufficient.
// Also, it doesn't deserve its own file. After the project is done it will be deleted without mercy.
class EmptyMainSubWindow extends MainSubWindow { 
  EmptyMainSubWindow(String name, {super.key}) : super(name: name);

  @override
  State<EmptyMainSubWindow> createState() => _EmptyMainSubWindowState();
}

class _EmptyMainSubWindowState extends State<EmptyMainSubWindow> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: 
      Text("Don't replace me 😭😭😭") // It cries at the thought of being just a useless class that will be replaced shortly.
    );
  }
}