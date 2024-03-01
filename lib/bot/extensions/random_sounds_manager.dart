import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_lavalink/nyxx_lavalink.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/util/bot_files.dart';
import 'package:umbrage_bot/bot/util/bot_timer.dart';
import 'package:umbrage_bot/bot/util/pseudo_random_index.dart';
import 'package:umbrage_bot/bot/util/random_cooldown.dart';
import 'package:umbrage_bot/bot/voice/music/music_queue.dart';
import 'package:umbrage_bot/bot/voice/music/music_track.dart';

class RandomSoundsManager {
  static final List<File> _sounds = [];
  static final Map<String, String> _soundUrls = {};
  static late PseudoRandomIndex _pseudoRandomIndex;
  static final _directory = BotFiles().getDir("random_sounds");


  late final BotTimer timer;
  final Snowflake _guildId;
  final MusicQueue _musicQueue;

  static List<File> get sounds => _sounds;

  RandomSoundsManager(this._musicQueue) : _guildId = _musicQueue.guildId {
    loadSounds();

    timer = BotTimer.periodic(() => Random().randomCooldown(Bot().config.randomSoundsMinCooldown, Bot().config.randomSoundsMaxCooldown), () async {
      if(!Bot().config.randomSoundsEnable) return;

      final guild = await Bot().client.guilds.get(_guildId);
      final botVoiceState = guild.voiceStates[Bot().user.id];
      if(botVoiceState == null || botVoiceState.channel == null || botVoiceState.isMuted) return; // Don't queue music if alone

      final file = _sounds[_pseudoRandomIndex.getNextIndex()];
      final filename = file.path.split("\\").last;
      
      // Sends the file to a personal throwaway discord account to save the file and play it.
      if(!_soundUrls.containsKey(filename)) {
        final dm = await Bot().client.users.createDm(const Snowflake(1062072022500397106));
        final message = await dm.sendMessage(MessageBuilder(attachments: [
          AttachmentBuilder(data: file.readAsBytesSync(), fileName: filename)
        ]));
        _soundUrls[filename] = message.attachments.first.url.toString();
      }

      await _musicQueue.initializePlayer();
      final result = await _musicQueue.lavalinkClient!.loadTrack(_soundUrls[filename]!);
      if(result is TrackLoadResult) {
        _queueTrack(result.data);
      } else {
        logging.logger.warning("NOT OK!");
      }
    });

    _musicQueue.onTrackQueued.listen((track) {
      if(Bot().config.randomSoundsLoop) {
        Timer(const Duration(milliseconds: 500), () async {
          if(!_musicQueue.loop && _musicQueue.currentTrack != null && _musicQueue.currentTrack!.hidden) {
            _musicQueue.toggleLoop(await Bot().getBotMember(_guildId));
          }
        });
      }
    });
  }

  void _queueTrack(Track track) async {
    if(_musicQueue.currentTrack != null) return;

    _musicQueue.queueSong(MusicTrack(
      track, 
      member: await Bot().getBotMember(_guildId),
      isUnskippable: Bot().config.botUnskippable,
      hidden: true
    ));
  }

  static void loadSounds() {
    _sounds.clear();
    _soundUrls.clear();

    for(final file in _directory.listSync()) {
      final filename = file.path.split(r'\').last;
      if(!filename.contains('.')) continue;

      final extension = filename.split('.').last;
      if(!['mp3', 'wav'].contains(extension)) continue;

      _sounds.add(File(file.path));
    }

    _pseudoRandomIndex = PseudoRandomIndex(_sounds.length);
  }

  static void setSounds(List<File> newFiles) {
    for(final file in _sounds) {
      if(!newFiles.map((e) => e.absolute.path).contains(file.absolute.path)) file.deleteSync();
    }

    for(final file in newFiles) {
      if(_sounds.contains(file)) continue;
      String filename = file.path.split('\\').last.split('.').first;
      final extension = file.path.split('.').last;
      String newPath = "${_directory.path}\\$filename.$extension";

      while(_directory.listSync().map((e) => e.path).contains(newPath)) {
        filename = '${filename}0';
        newPath = "${_directory.path}\\$filename.$extension";
      }

      file.copySync(newPath);
    }

    loadSounds();
  }
}