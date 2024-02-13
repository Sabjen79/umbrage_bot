import 'dart:async';
import 'dart:collection';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_lavalink/nyxx_lavalink.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/util/pair.dart';
import 'package:umbrage_bot/bot/voice/music/util/music_command_message.dart';
import 'package:umbrage_bot/bot/voice/music/music_track.dart';

class MusicQueue {
  final Snowflake guildId;
  late final LavalinkPlayer _player;
  final Queue<MusicTrack> _queue = Queue();
  Timer? unskipTimer;
  MusicTrack? currentTrack;
  bool _loop = false;

  // Streams
  final StreamController<MusicTrack> _queuedTrackStream = StreamController<MusicTrack>();
  final StreamController<Pair<MusicTrack, Member>> _skippedTrackStream = StreamController<Pair<MusicTrack, Member>>();
  final StreamController<Pair<Member, bool>> _loopChangedStream = StreamController<Pair<Member, bool>>();

  Stream<MusicTrack> get onTrackQueued => _queuedTrackStream.stream;
  Stream<Pair<MusicTrack, Member>> get onTrackSkipped => _skippedTrackStream.stream;
  Stream<Pair<Member, bool>> get onLoopChanged => _loopChangedStream.stream;
  //

  LavalinkClient get lavalinkClient => _player.lavalinkClient;

  MusicQueue(this.guildId) {
    var plugin = Bot().client.options.plugins.firstWhere((element) => element is LavalinkPlugin) as LavalinkPlugin;
    plugin.onPlayerConnected.firstWhere((player) => player.guildId == guildId).then((player) {
      _player = player;

      _player.onTrackEnd.listen((e) {
        if(e.reason == "finished") _nextTrack();
      });
      _player.onTrackStuck.listen((e) {_nextTrack();});
      _player.onTrackException.listen(_trackException);
    });

    MusicCommandMessage(this); // Music messages
  }

  void queueSong(MusicTrack track) {
    _queue.add(track);

    _queuedTrackStream.add(track);

    if(currentTrack == null) {
      _nextTrack();
    }
  }

  bool containsTrack(MusicTrack track) {
    final list = _queue.toList();
    if(currentTrack != null) {
      list.add(currentTrack!);
    }

    for(var t in list) {
      if(t.track.encoded == track.track.encoded) return true;
    }

    return false;
  }

  void skip(Member member) {
    if(currentTrack == null) return;

    _skippedTrackStream.add(Pair(currentTrack!, member));
    
    _nextTrack(true);
  }

  void toggleLoop(Member member) {
    if(currentTrack == null) return;

    _loop = !_loop;
    _loopChangedStream.add(Pair(member, _loop));
  }

  void replayCurrentTrack() {
    if(currentTrack == null || _player.currentTrack != null) return;

    _player.playEncoded(currentTrack!.track.encoded);
    _player.seekTo(_player.state.position);
  }

  void _nextTrack([bool forced = false]) {
    _player.stopPlaying().then((v) {
      if(_loop && !forced) {
        _player.playEncoded(currentTrack!.track.encoded);
        return;
      }

      currentTrack = null;
      unskipTimer?.cancel();

      if(_queue.isNotEmpty) {
        currentTrack = _queue.removeLast();
        _player.playEncoded(currentTrack!.track.encoded);

        // Unskip timer
        if(currentTrack!.isUnskippable) {
          unskipTimer = Timer(Duration(milliseconds: Bot().config.randomUnskippableDuration), () {
            currentTrack?.isUnskippable = false;
          });
        }
      }
    });
  }

  void _trackException(TrackExceptionEvent event) {

  }
}