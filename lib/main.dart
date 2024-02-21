import 'dart:io';
import 'package:flutter/material.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';
import 'package:umbrage_bot/ui/start_menu/start_menu.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  windowManager.setIgnoreMouseEvents(false);
  if (Platform.isWindows) {
    WindowManager.instance.setMinimumSize(const Size(1000, 600));
  }

  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Umbrage Bot",
      theme: DiscordTheme.get(),
      home: const StartMenu(),
    );
  }
}