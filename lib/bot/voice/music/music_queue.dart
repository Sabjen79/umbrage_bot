import 'dart:async';
import 'dart:collection';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_lavalink/nyxx_lavalink.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/util/bot_timer.dart';
import 'package:umbrage_bot/bot/util/pair.dart';
import 'package:umbrage_bot/bot/voice/music/util/music_command_message.dart';
import 'package:umbrage_bot/bot/voice/music/music_track.dart';

class MusicQueue {
  final Snowflake guildId;
  late final LavalinkPlayer _player;
  final Queue<MusicTrack> _queue = Queue();
  BotTimer? unskipTimer;
  MusicTrack? currentTrack;
  bool _loop = false;

  // Streams
  final StreamController<MusicTrack> _queuedTrackStream = StreamController<MusicTrack>.broadcast();
  final StreamController<Pair<MusicTrack, Member>> _skippedTrackStream = StreamController<Pair<MusicTrack, Member>>.broadcast();
  final StreamController<Pair<Member, bool>> _loopChangedStream = StreamController<Pair<Member, bool>>.broadcast();
  final StreamController<void> _queueChangedStream = StreamController<void>.broadcast();
  final StreamController<MusicTrack?> _currentTrackChangedStream = StreamController<MusicTrack?>.broadcast();

  Stream<MusicTrack> get onTrackQueued => _queuedTrackStream.stream.asBroadcastStream();
  Stream<Pair<MusicTrack, Member>> get onTrackSkipped => _skippedTrackStream.stream.asBroadcastStream();
  Stream<Pair<Member, bool>> get onLoopChanged => _loopChangedStream.stream.asBroadcastStream();
  Stream<void> get onQueueChanged => _queueChangedStream.stream.asBroadcastStream();
  Stream<MusicTrack?> get onCurrentTrackChanged => _currentTrackChangedStream.stream.asBroadcastStream();
  //

  LavalinkClient get lavalinkClient => _player.lavalinkClient;
  List<MusicTrack> get list => _queue.toList();
  bool get loop => _loop;

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

    Bot().client.onVoiceStateUpdate.listen((event) {
      //Ensures that the bot will not play music while there is nobody to hear it
      final botState = event.state.guild?.voiceStates[Bot().user.id];
      if(botState == null || currentTrack == null) return;

      if(botState.channel == null || botState.isMuted) {
        _player.pause();
      } else {
        _player.resume();
      }
    });

    MusicCommandMessage(this); // Music messages
  }

  bool containsTrack(MusicTrack track) {
    if(currentTrack != null) {
      list.add(currentTrack!);
    }

    for(var t in list) {
      if(t.track.encoded == track.track.encoded) return true;
    }

    return false;
  }

  void queueSong(MusicTrack track) {
    _queue.add(track);

    _queuedTrackStream.add(track);
    _queueChangedStream.add(null);

    if(currentTrack == null) {
      _nextTrack();
    }
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
      unskipTimer?.timer.cancel();

      if(_queue.isNotEmpty) {
        currentTrack = _queue.removeFirst();
        _player.playEncoded(currentTrack!.track.encoded);

        _queueChangedStream.add(null);

        // Unskip timer
        if(currentTrack!.isUnskippable) {
          unskipTimer = BotTimer(Duration(milliseconds: Bot().config.randomUnskippableDuration), () {
            currentTrack?.isUnskippable = false;
          });
        }
      }

      _currentTrackChangedStream.add(currentTrack);
    });
  }

  void _trackException(TrackExceptionEvent event) {

  }
}