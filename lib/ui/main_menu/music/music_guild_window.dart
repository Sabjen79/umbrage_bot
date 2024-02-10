import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/ui/components/simple_discord_button.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_menu_router.dart';

class MusicGuildWindow extends MainWindow {
  final Guild guild;

  MusicGuildWindow(this.guild, {super.key}) : super(
    name: guild.name,
    route: guild.id.toString(),
    sideBarIcon: Symbols.groups,
  );

  @override
  State<MusicGuildWindow> createState() => _MusicGuildWindowState();
}

class _MusicGuildWindowState extends State<MusicGuildWindow> {


  @override
  Widget build(BuildContext context) {
    return Bot().config[widget.guild.id].musicChannelId == 0 ?
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Guild ${widget.guild.name} doesn't have a music channel set."),
          Container(
            padding: const EdgeInsets.only(top: 10)
          ),
          SimpleDiscordButton(
            width: 100,
            height: 30,
            text: "Go to settings",
            onTap: () async {
              MainMenuRouter().routeTo("settings/${widget.guild.id.toString()}");
            },
          )
        ],
      ),
    ) :
    Text("DAB");
  }
}