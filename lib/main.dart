import 'dart:io';

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';
import 'package:umbrage_bot/ui/main_menu/windows/console/console_window.dart';
import 'package:umbrage_bot/ui/start_menu/start_menu.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  FlutterWindowClose.setWindowShouldCloseHandler(() async => true);
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  windowManager.setIgnoreMouseEvents(false);
  if (Platform.isWindows) {
    WindowManager.instance.setMinimumSize(const Size(1000, 600));
  }

  // Console Output
  ConsoleWindow.buffer = StringBuffer();
  logging.logger.onRecord.listen((event) {
    ConsoleWindow.buffer.writeln("[${event.time.toString()}] ${event.toString()}");
  });

  PlatformDispatcher.instance.onError = (object, stack) {
    logging.logger.severe("${object.toString()}:\n${stack.toString()}");
    return true;
  };
  
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