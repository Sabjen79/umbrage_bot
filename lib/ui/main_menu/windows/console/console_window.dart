import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';
import 'package:umbrage_bot/ui/main_menu/main_menu.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';

class ConsoleWindow extends MainWindow {
  static late StringBuffer buffer;

  const ConsoleWindow({super.key}) : super(
    name: "console",
    route: "console"
  );

  @override
  State<ConsoleWindow> createState() => _ConsoleWindowState();
}

class _ConsoleWindowState extends State<ConsoleWindow> {
  late final ScrollController _controller;
  late final StreamSubscription _subscription;
  bool _firstBuild = false;

  @override
  void initState() {
    super.initState();
    _subscription = logging.logger.onRecord.listen((event) {
      if(_controller.position.maxScrollExtent - _controller.position.pixels < 60) {
        _controller.jumpTo(_controller.position.maxScrollExtent);
      }
      setState(() {});
    });

    _controller = ScrollController();
  }

  @override
  void dispose() {
    _subscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(_controller.hasClients && _firstBuild == false) {
      _controller.jumpTo(_controller.position.maxScrollExtent);
      _firstBuild = true;
    }

    return Container(
      width: MainMenu.getMainWindowWidth(context),
      height: MediaQuery.of(context).size.height,
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: DiscordTheme.black
      ),
      child: ListView(
        controller: _controller,
        children: [
          SelectableText(ConsoleWindow.buffer.toString())
        ],
      )
    );
  }
}