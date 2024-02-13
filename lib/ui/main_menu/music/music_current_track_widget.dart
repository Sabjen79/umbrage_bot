import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/voice/music/music_queue.dart';
import 'package:umbrage_bot/bot/voice/music/music_track.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';
import 'package:umbrage_bot/ui/main_menu/main_menu.dart';

class MusicCurrentTrackWidget extends StatefulWidget {
  final Snowflake guildId;
  const MusicCurrentTrackWidget(this.guildId, {super.key});

  @override
  State<MusicCurrentTrackWidget> createState() => _MusicCurrentTrackWidgetState();
}

class _MusicCurrentTrackWidgetState extends State<MusicCurrentTrackWidget> {
  late final MusicQueue _queue;
  MusicTrack? currentTrack;
  late final StreamSubscription _onCurrentTrackChanged;
  late final StreamSubscription _onLoopChanged;
  late final Timer _unskipTimer;

  @override
  void initState() {
    super.initState();
    
    _queue = Bot().voiceManager[widget.guildId].music.queue;
    currentTrack = _queue.currentTrack;
    _onCurrentTrackChanged = _queue.onCurrentTrackChanged.listen((track) {
      setState(() {
        currentTrack = track;
      });
    });

    _onLoopChanged = _queue.onLoopChanged.listen((_) {
      setState(() {});
    });

    _unskipTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _onCurrentTrackChanged.cancel();
    _onLoopChanged.cancel();
    _unskipTimer.cancel();
    super.dispose();
  }

  String _getUnskipString() {
    if(_queue.unskipTimer == null) return "";
    var ms = _queue.unskipTimer!.runTime.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch;
    return Duration(milliseconds: ms).toString().split('.')[0];
  }

  Widget buildNoTrack(String text) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500
        ),
      ),
    );
  }

  Widget buildTrack() {
    if(currentTrack == null) return buildNoTrack("No Track Playing");

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10)
          ),
          clipBehavior: Clip.hardEdge,
          width: 200,
          height: 200,
          margin: const EdgeInsets.only(right: 10),
          child: currentTrack?.track.info.artworkUrl == null ? 
            Container(color: DiscordTheme.backgroundColorLight) : 
            Image.network(
              currentTrack!.track.info.artworkUrl.toString(),
              fit: BoxFit.cover,
            ),
        ),
        SizedBox(
          width: MainMenu.getMainWindowWidth(context)*0.65 - 240,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentTrack!.track.info.title,
                maxLines: 2,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  overflow: TextOverflow.ellipsis
                ),
              ),
              
              Text(
                currentTrack!.track.info.author,
                style: const TextStyle(
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis
                    ),
                    children: [
                      const TextSpan(text: "Added by: ", style: TextStyle(color: DiscordTheme.lightGray)),
                      TextSpan(text: currentTrack!.member.user!.username, style: const TextStyle(fontWeight: FontWeight.w500)),
                    ]
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis
                  ),
                  children: [
                    const TextSpan(text: "Unskippable: ", style: TextStyle(color: Color(0xffffdc4e))),
                    TextSpan(text: currentTrack!.isUnskippable ? "YES (${_getUnskipString()} left)" : "NO", style: const TextStyle(fontWeight: FontWeight.w500)),
                  ]
                ),
              ),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis
                  ),
                  children: [
                    const TextSpan(text: "Loop: ", style: TextStyle(color: DiscordTheme.primaryColor)),
                    TextSpan(text: _queue.loop ? "ON" : "OFF", style: const TextStyle(fontWeight: FontWeight.w500)),
                  ]
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.only(right: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: MainMenu.getMainWindowWidth(context)*0.65,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: DiscordTheme.black
      ),
      child: buildTrack()
    ); 
  }
}