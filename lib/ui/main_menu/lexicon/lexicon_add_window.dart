import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/ui/main_menu/main_sub_window.dart';

class LexiconAddWindow extends MainSubWindow {
  LexiconAddWindow({super.key}) : super(name: "Add New Variable", sideBarIcon: Symbols.add_circle);

  @override
  State<LexiconAddWindow> createState() => _LexiconAddWindowState();
}

class _LexiconAddWindowState extends State<LexiconAddWindow> {
  
  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}