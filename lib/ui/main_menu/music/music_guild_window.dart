import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/ui/components/simple_discord_button.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';
import 'package:umbrage_bot/ui/main_menu/music/music_current_track_widget.dart';
import 'package:umbrage_bot/ui/main_menu/music/music_queue_widget.dart';
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

  Widget _wip() {
    return Container(
      decoration: BoxDecoration(
        color: DiscordTheme.black,
        borderRadius: BorderRadius.circular(10)
      ),
      child: const Center(child: Text("WIP")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Bot().config[widget.guild.id].musicChannelId == 0 ?
    Center( // No Music Channel
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Music is disabled", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24)),
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
    ListView( // With Music Channel
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              height: 200,
              child: Row(
                children: [
                  MusicCurrentTrackWidget(widget.guild.id),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: _wip(),
                        ),
                        const SizedBox(height: 5),
                        Expanded(
                          child: _wip(),
                        )
                      ],
                    )
                  ),
                ],
              ),
            ),
            MusicQueueWidget(widget.guild.id)
          ],
        )
      ],
    );
  }
}