import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/util/member_name.dart';
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
  late MusicQueue _queue;
  late StreamSubscription _onQueueChanged;

  @override
  void initState() {
    super.initState();

    refresh();
  }

  @override
  void didUpdateWidget(covariant MusicQueueWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _onQueueChanged.cancel();
    refresh();
  }

  @override
  void dispose() {
    _onQueueChanged.cancel();
    super.dispose();
  }

  void refresh() {
    _queue = Bot().voiceManager[widget.guildId].music.queue;

    _onQueueChanged = _queue.onQueueChanged.listen((event) {
      setState(() {});
    });
  }

  Widget verticalDivider() {
    return Container(
      width: 1.5,
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 7),
      color: DiscordTheme.darkGray
    );
  }

  Color entryColor(MusicTrack? track, bool even) {
    if(track == null) return _queue.list.isEmpty ? DiscordTheme.black : DiscordTheme.backgroundColorDarkest;

    return even ? Color.lerp(DiscordTheme.black, DiscordTheme.darkGray, 0.4)! : DiscordTheme.black;
  }

  Widget listEntry(MusicTrack? track, bool even) {
    return Container(
      color: entryColor(track, even),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
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
          
          verticalDivider(),

          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                textAlign: TextAlign.center,
                track == null ? "Author" : track.track.info.author,
                style: TextStyle(
                  color: DiscordTheme.white2,
                  fontWeight: track == null ? FontWeight.w500 : FontWeight.normal,
                  overflow: TextOverflow.ellipsis
                )
              )
            )
          ),
          
          verticalDivider(),

          SizedBox(
            width: 90,
            child: Text(
              textAlign: TextAlign.center,
              track == null ? "Duration" : track.track.info.length.toString().split('.')[0],
              style: TextStyle(
                color: DiscordTheme.white2,
                fontWeight: track == null ? FontWeight.w500 : FontWeight.normal
              ),
            ),
          ),

          verticalDivider(),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            width: 135,
            child: Text(
              textAlign: TextAlign.center,
              track == null ? "Added By" : track.member.effectiveName,
              style: TextStyle(
                color: Bot().user.id == track?.member.id ? DiscordTheme.primaryColor : DiscordTheme.white2,
                fontWeight: track == null || Bot().user.id == track.member.id ? FontWeight.w500 : FontWeight.normal,
                overflow: TextOverflow.ellipsis
              ),
            ),
          ),

          verticalDivider(),

          SizedBox(
            width: 110,
            child: Text(
              track == null ? "Unskippable" : track.isUnskippable ? "✅" : "⛔",
              textAlign: TextAlign.center,
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
          list.add(listEntry(null, false));

          bool even = false;
          for(var s in _queue.list) {
            list.add(listEntry(s, even));
            even = !even;
          }

          return list;
        }(),
      ),
    );
  }
}