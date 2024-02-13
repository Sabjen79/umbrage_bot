import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/voice/music/music_queue.dart';
import 'package:umbrage_bot/bot/voice/music/music_track.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';

class MusicQueueWidget extends StatefulWidget {
  final Snowflake guildId;
  const MusicQueueWidget(this.guildId, {super.key});

  @override
  State<MusicQueueWidget> createState() => _MusicQueueWidgetState();
}

class _MusicQueueWidgetState extends State<MusicQueueWidget> {
  late final MusicQueue _queue;
  late final StreamSubscription _onQueueChanged;

  @override
  void initState() {
    super.initState();

    _queue = Bot().voiceManager[widget.guildId].music.queue;
    _onQueueChanged = _queue.onQueueChanged.listen((event) {
      setState(() {
        
      });
    });
  }

  @override
  void dispose() {
    _onQueueChanged.cancel();
    super.dispose();
  }

  void refresh() {
    _queue = Bot().voiceManager[widget.guildId].music.queue;
  }

  Widget listEntry(MusicTrack? track) {
    return Container(
      color: track == null ? _queue.list.isEmpty ? DiscordTheme.black : DiscordTheme.backgroundColorDarkest : Colors.transparent,
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                track == null ? "Name" : track.track.info.title,
                style: TextStyle(
                  color: DiscordTheme.white2,
                  fontWeight: track == null ? FontWeight.w500 : FontWeight.normal,
                  overflow: TextOverflow.ellipsis
                ),
              ),
            ),
          ),
          
          Expanded(
            flex: 1,
            child: SizedBox(
              child: Text(
                track == null ? "Author" : track.track.info.author,
                style: TextStyle(
                  color: DiscordTheme.white2,
                  fontWeight: track == null ? FontWeight.w500 : FontWeight.normal,
                  overflow: TextOverflow.ellipsis
                )
              )
            )
          ),
          
          SizedBox(
            width: 90,
            child: Text(
              track == null ? "Duration" : track.track.info.length.toString().split('.')[0],
              style: TextStyle(
                color: DiscordTheme.white2,
                fontWeight: track == null ? FontWeight.w500 : FontWeight.normal
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              track == null ? "User" : track.member.user!.username,
              style: TextStyle(
                color: DiscordTheme.white2,
                fontWeight: track == null ? FontWeight.w500 : FontWeight.normal,
                overflow: TextOverflow.ellipsis
              ),
            ),
          ),
          SizedBox(
            width: 110,
            child: Text(
              track == null ? "Unskippable" : track.isUnskippable ? "Yes" : "No",
              style: TextStyle(
                color: DiscordTheme.white2,
                fontWeight: track == null ? FontWeight.w500 : FontWeight.normal
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: DiscordTheme.black,
        borderRadius: BorderRadius.circular(5)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: () {
          var list = <Widget>[];
          list.add(listEntry(null));

          for(var s in _queue.list) {
            list.add(listEntry(s));
          }

          return list;
        }(),
      ),
    );
  }
}