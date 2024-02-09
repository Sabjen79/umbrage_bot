import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';

class GuildSettingsWindow extends MainWindow {
  GuildSettingsWindow(Guild g, {super.key}) : super(
    route: g.id.toString(),
    name: g.name,
    sideBarIcon: Symbols.dns,
    category: "Guild Settings"
  );
  
  @override
  State<GuildSettingsWindow> createState() => _GuildSettingsWindowState();
}

class _GuildSettingsWindowState extends State<GuildSettingsWindow> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}