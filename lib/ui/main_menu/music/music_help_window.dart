import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';
import 'package:umbrage_bot/ui/main_menu/main_menu.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';

class MusicHelpWindow extends MainWindow {
  const MusicHelpWindow({super.key}) : super(
    name: "Chat Commands",
    route: "help",
    sideBarIcon: Symbols.help,
  );

  @override
  State<MusicHelpWindow> createState() => _MusicHelpWindowState();
}

class _MusicHelpWindowState extends State<MusicHelpWindow> {

  Widget _command({required String command1, required String command2, required String description}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: command1,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: DiscordTheme.primaryColor,
                fontSize: 18
              )
            ),
            const TextSpan(
              text: " / ",
              style: TextStyle(
                fontSize: 18
              )
            ),
            TextSpan(
              text: command2,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: DiscordTheme.primaryColor,
                fontSize: 18
              )
            ),
            TextSpan(
              text: " - $description",
              style: const TextStyle(
                fontSize: 14
              )
            ),
          ]
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MainMenu.getMainWindowWidth(context)*0.8,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          color: DiscordTheme.backgroundColorDarker,
          borderRadius: BorderRadius.circular(10)
        ),
        child: IntrinsicHeight(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(bottom: 10),
                child: const Text("These commands can only be used in the dedicated music text channel, defined in settings."),
              ),
              _command(
                command1: "-play <link>",
                command2: "-p <link>",
                description: "Adds a song to the queue. If youtube api is included in the settings, the link can be replaced with a query that is searched on youtube, queing the first search result."
              ),
              _command(
                command1: "-skip",
                command2: "-s",
                description: "Skips the current music track, if possible."
              ),
              _command(
                command1: "-loop",
                command2: "-l",
                description: "Toggles the loop. When enabled, the current song will repeat itself after it finishes."
              ),
              _command(
                command1: "-clear",
                command2: "-c",
                description: "Clears the queue, if possible."
              )
            ]
          )
        )
      ),
    );
  }
}