import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/ui/components/simple_discord_button.dart';
import 'package:umbrage_bot/ui/main_menu/main_menu.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';
import 'package:umbrage_bot/ui/main_menu/windows/music/guild_window/music_current_track_widget.dart';
import 'package:umbrage_bot/ui/main_menu/windows/music/guild_window/music_queue_widget.dart';
import 'package:umbrage_bot/ui/main_menu/windows/music/guild_window/music_timer_widget.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_menu_router.dart';

class MusicGuildWindow extends MainWindow {
  final Guild guild;

  MusicGuildWindow(this.guild, {super.key}) : super(
    name: guild.name,
    route: guild.id.toString(),
    category: "GUILDS",
    sideBarIcon: Symbols.groups,
  );

  @override
  State<MusicGuildWindow> createState() => _MusicGuildWindowState();
}

class _MusicGuildWindowState extends State<MusicGuildWindow> {

  @override
  void didUpdateWidget(covariant MusicGuildWindow oldWidget) {
    super.didUpdateWidget(oldWidget);

    if(mounted) setState(() {});
  }

  List<Widget> _sideWidgets() {
    var list = <Widget>[];

    if(Bot().config.randomMusicEnable) {
      list.add(
        MusicTimerWidget(
          name: "Random Music",
          timer: Bot().voiceManager[widget.guild.id].music.randomMusicManager.timer
        ),
      );
    }

    if(Bot().config.randomSoundsEnable) {
      list.add(
        MusicTimerWidget(
          name: "Random Sounds",
          timer: Bot().voiceManager[widget.guild.id].music.randomSoundsManager.timer
        ),
      );
    }
    
    if(Bot().config.volumeBoostEnable) {
      list.add(
        MusicTimerWidget(
          name: "Volume Boost",
          timer: Bot().voiceManager[widget.guild.id].music.volumeBoostManager.timer
        ),
      );
    }
    
    return list;
  }

  @override
  Widget build(BuildContext context) {
    var sideWidgets = _sideWidgets();

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
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.center,
                children: sideWidgets,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 5, left: 20, right: 15),
              width: MainMenu.getMainWindowWidth(context),
              height: 200,
              child: MusicCurrentTrackWidget(
                widget.guild.id,
              )
            ),
            MusicQueueWidget(widget.guild.id)
          ],
        )
      ],
    );
  }
}