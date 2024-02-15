import 'dart:async';
import 'dart:math';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_lavalink/nyxx_lavalink.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/util/bot_files.dart';
import 'package:umbrage_bot/bot/util/bot_timer.dart';
import 'package:umbrage_bot/bot/util/json_serializable.dart';
import 'package:umbrage_bot/bot/voice/music/music_queue.dart';
import 'package:umbrage_bot/bot/voice/music/music_track.dart';

class RandomMusicManager with JsonSerializable {
  final MusicQueue _queue;
  final Snowflake guildId;
  BotTimer? timer;
  List<String> _songList = [];

  RandomMusicManager(this._queue) : guildId = _queue.guildId {
    _loadSongs();

    _queue.onTrackQueued.listen((track) {
      _addToList(track);
    });

    timer = BotTimer.periodic(() => Bot().config.randomMusicCooldown, () async {
      String url = "";
      while(url.isEmpty && _songList.isNotEmpty && Bot().config.randomMusicEnable) {
        url = _songList[Random().nextInt(_songList.length)];

        try {
          var result = await _queue.lavalinkClient.loadTrack(url);
          if(result is TrackLoadResult) {
            _queueTrack(result);
          } else {
            _removeFromList(url);
            url = "";
          }
        } on LavalinkException {
          _removeFromList(url);
          url = "";
        }
      }
    });
  }

  void _queueTrack(TrackLoadResult result) async {
    final guild = await Bot().client.guilds.get(guildId);
    final botVoiceState = guild.voiceStates[Bot().user.id];
    if(botVoiceState == null || botVoiceState.channel == null || botVoiceState.isMuted) return; // Don't queue music if alone

    // Check if skip
    bool skip = false;
    if(_queue.currentTrack != null && _queue.currentTrack!.member.id != Bot().user.id 
      && _queue.list.isEmpty && Random().nextDouble() < Bot().config.randomMusicSkipChance) {
      skip = true;
    }

    _queue.queueSong(MusicTrack(
      result.data,
      member: await Bot().getBotMember(guildId),
      isUnskippable: Bot().config.botUnskippable
    ));

    if(skip) {
      Timer(const Duration(seconds: 5), () async {
        if(_queue.currentTrack?.member.id == Bot().user.id) return;

        _queue.skip(await Bot().getBotMember(guildId));
      });
    }
  }

  void _addToList(MusicTrack track) {
    var url = track.track.info.uri?.toString();
    if(url == null) return;

    // Shorten youtube url, if possible
    if(url.startsWith(r"https://www.youtube.com/watch?v=")) {
      url = "https://youtu.be/${url.substring(32, 43)}"; // Yt video id is 11 characters long
    }

    if(!_songList.contains(url)) {
      _songList.add(url);
      saveToJson();
    }
  }

  void _removeFromList(String url) {
    if(_songList.contains(url)) {
      _songList.remove(url);
      saveToJson();
    }
  }

  void _loadSongs() {
    var json = loadFromJson();

    _songList = List<String>.from((json['songList'] ?? <String>[]));
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'songList': _songList
    };
  }
  
  @override
  String get jsonFilepath => "${BotFiles().getMainDir().path}/guilds/${guildId.toString()}/saved_songs.json";
}