import 'dart:io';
import 'package:auto_exit_process/auto_exit_process.dart' as aep;

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:nyxx/nyxx.dart';
import 'package:path_provider/path_provider.dart';
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

  startLavalinkServer();
  
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

void startLavalinkServer() async {
  Directory dir = await getApplicationSupportDirectory();

  ByteData lavalinkJarData = await rootBundle.load("assets/Lavalink.jar");
  File lavalinkJar = File("${dir.path}/Lavalink.jar");
  if(!lavalinkJar.existsSync()) {
    lavalinkJar.writeAsBytesSync(Uint8List.sublistView(lavalinkJarData));
  }

  ByteData lavalinkConfigData = await rootBundle.load("assets/application.yaml");
  File lavalinkConfig = File("${dir.path}/application.yaml");
  if(!lavalinkConfig.existsSync()) {
    lavalinkConfig.writeAsBytesSync(Uint8List.sublistView(lavalinkConfigData));
  }

  await aep.Process.start("java", [
    "-jar",
    "Lavalink.jar"
  ], workingDirectory: dir.absolute.path, runInShell: true);
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