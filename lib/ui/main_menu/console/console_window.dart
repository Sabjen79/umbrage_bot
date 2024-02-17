import 'dart:async';

import 'package:flutter/material.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/util/streamable_string_buffer.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';
import 'package:umbrage_bot/ui/main_menu/main_menu.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';

class ConsoleWindow extends MainWindow {
  const ConsoleWindow({super.key}) : super(
    name: "console",
    route: "console"
  );

  @override
  State<ConsoleWindow> createState() => _ConsoleWindowState();
}

class _ConsoleWindowState extends State<ConsoleWindow> {
  final StreamableStringBuffer buffer = Bot().logging.stdout as StreamableStringBuffer;
  late final StreamSubscription _streamSubscription;
  late final ScrollController _controller;
  bool _firstBuild = false;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();

    _streamSubscription = buffer.onChanged.listen((event) {
      if(_controller.position.maxScrollExtent - _controller.position.pixels < 60) {
        _controller.jumpTo(_controller.position.maxScrollExtent);
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
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
          Text(buffer.toString())
        ],
      )
    );
  }
}