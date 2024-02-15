// ignore_for_file: unused_field

import 'dart:async';

import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/util/bot_timer.dart';
import 'package:umbrage_bot/bot/voice/music/music_queue.dart';

class VolumeBoostManager {
  final Snowflake _guildId;
  final MusicQueue _queue;
  BotTimer? timer;

  VolumeBoostManager(this._queue) : _guildId = _queue.guildId {
    timer = BotTimer.periodic(() => Bot().config.volumeBoostCooldown, () async {
      if(!Bot().config.volumeBoostEnable) return;

      _ascendVolume();
      
      Timer(const Duration(seconds: 4), () {
        _descendVolume();
      });
    });
  }

  Future<void> _ascendVolume() async {
    for(double i = 0; i <= 1; i += 0.1) {
      await Future.delayed(const Duration(milliseconds: 50));
      _queue.player.setVolume(100 + (i * (Bot().config.volumeBoostAmplitude - 100)).toInt());
    }
  }

  Future<void> _descendVolume() async {
    for(double i = 1; i >= 0; i -= 0.1) {
      await Future.delayed(const Duration(milliseconds: 50));
      _queue.player.setVolume(100 + (i * (Bot().config.volumeBoostAmplitude - 100)).toInt());
    }
  }
}