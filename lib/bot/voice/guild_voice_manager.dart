import 'dart:collection';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_lavalink/nyxx_lavalink.dart' as lavalink;
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/voice/guild_music_manager.dart';

class GuildVoiceManager {
  final PartialGuild guild;
  final GuildMusicManager music;

  GuildVoiceManager(this.guild) : music = GuildMusicManager(guild);

  void handleEvent(VoiceStateUpdateEvent event) async {
    var botState = event.state.guild!.voiceStates[Bot().user.id];

    if(Bot().config.autoConnectVoice) _autoConnect(botState);
  }

  void connectTo(GuildVoiceChannel vc) async {
    Bot().client.updateVoiceState(guild.id, GatewayVoiceStateBuilder(
      channelId: vc.id, 
      isMuted: false, 
      isDeafened: false
    ));

    music.player ??= await vc.connectLavalink();
  }

  void disconnect() async {
    Bot().client.updateVoiceState(guild.id, GatewayVoiceStateBuilder(
      channelId: null, 
      isMuted: false, 
      isDeafened: false
    ));
  }

  void _autoConnect(VoiceState? botState) async {
    // TODO: Better calculation
    Map<PartialChannel, int> points = {};

    for(var vs in guild.voiceStates.values) {
      if(vs.userId != Bot().user.id && !vs.isDeafened && vs.channel != null) {
        points[vs.channel!] ??= 0;
        points[vs.channel!] = points[vs.channel!]! + 1;
      }
    }

    if(points.isEmpty) {
      if(Bot().config.autoConnectVoicePersist && botState != null) {
        Bot().client.updateVoiceState(guild.id, GatewayVoiceStateBuilder(
          channelId: botState.channelId, 
          isMuted: true, 
          isDeafened: false
        ));
      } else {
        disconnect();
      }
      
      return;
    }

    final sorted = SplayTreeMap<PartialChannel, int>.from(points, (key1, key2) => points[key1]!.compareTo(points[key2]!));

    final channel = await Bot().client.channels.fetch(sorted.keys.last.id) as GuildVoiceChannel; // Get the vc with the highest score
    
    connectTo(channel);
  }
}