import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/util/member_name.dart';
import 'package:umbrage_bot/bot/voice/music/music_queue.dart';
import 'package:umbrage_bot/bot/voice/music/music_track.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';

class MusicCurrentTrackWidget extends StatefulWidget {
  final Snowflake guildId;

  const MusicCurrentTrackWidget(this.guildId, {super.key});

  @override
  State<MusicCurrentTrackWidget> createState() => _MusicCurrentTrackWidgetState();
}

class _MusicCurrentTrackWidgetState extends State<MusicCurrentTrackWidget> {
  late MusicQueue _queue;
  MusicTrack? currentTrack;
  late StreamSubscription _onCurrentTrackChanged;
  late StreamSubscription _onLoopChanged;
  late final Timer _unskipTimer;

  @override
  void initState() {
    super.initState();
    
    _unskipTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });

    refresh();
  }

  @override
  void didUpdateWidget(covariant MusicCurrentTrackWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _onCurrentTrackChanged.cancel();
    _onLoopChanged.cancel();
    refresh();
  }

  void refresh() {
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
      mainAxisSize: MainAxisSize.max,
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
        Flexible(
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
                      TextSpan(
                        text: currentTrack!.member.effectiveName, 
                        style: TextStyle(
                          color: Bot().user.id == currentTrack?.member.id ? DiscordTheme.primaryColor : DiscordTheme.white2,
                          fontWeight: FontWeight.w500,
                        )
                      ),
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
                    const TextSpan(text: "Unskippable: ", style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xffffdc4e))),
                    TextSpan(
                      text: currentTrack!.isUnskippable ? "✅ (${_getUnskipString()} left)" : "⛔", 
                    ),
                  ]
                ),
              ),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis
                  ),
                  children: [
                    const TextSpan(text: "Loop: ", style: TextStyle(color: DiscordTheme.primaryColor, fontWeight: FontWeight.w500)),
                    TextSpan(text: _queue.loop ? "✅" : "⛔", style: const TextStyle(fontWeight: FontWeight.w500)),
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
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: DiscordTheme.black
      ),
      child: buildTrack()
    ); 
  }
}