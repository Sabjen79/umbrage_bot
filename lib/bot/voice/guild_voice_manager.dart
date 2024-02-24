import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/voice/music/guild_music_manager.dart';

class GuildVoiceManager {
  final PartialGuild guild;
  late final Snowflake? afk; // To stay away from this
  final GuildMusicManager music;

  GuildVoiceManager(this.guild) : music = GuildMusicManager(guild) {
    guild.get().then((value) => afk = value.afkChannelId);
    Future.delayed(const Duration(seconds: 3)).then((value) {
      _autoConnect(guild.voiceStates[Bot().user.id]);
    });
  }

  void handleEvent(VoiceStateUpdateEvent event) async {
    final botState = guild.voiceStates[Bot().user.id];
    print("OK");

    _autoConnect(botState);
  }

  bool get isBotReadyForAudio {
    final botState = guild.voiceStates[Bot().user.id];
    if(botState == null || botState.channel == null || botState.isSelfMuted) return false;
    return true;
  }

  void connectTo(Snowflake? id, [bool muted = false]) async {
    Bot().client.updateVoiceState(guild.id, GatewayVoiceStateBuilder(
      channelId: id, 
      isMuted: muted, 
      isDeafened: false
    ));
  }

  void disconnect() async {
    Bot().client.updateVoiceState(guild.id, GatewayVoiceStateBuilder(
      channelId: null, 
      isMuted: false, 
      isDeafened: false
    ));
  }

  void _autoConnect(VoiceState? botState) async {
    if(!Bot().config.autoConnectVoice) return;

    Map<PartialChannel, int> points = {};
    var maxpoints = 0;
    PartialChannel? bestChannel;

    for(var vs in guild.voiceStates.values) {
      if(!vs.isDeafened && vs.channel != null && vs.channelId != afk) {
        points[vs.channel!] ??= 0;
        points[vs.channel!] = points[vs.channel!]! + (vs.user == Bot().user ? 1 : 2); // The bot will prefer to remain in his voice channel
        
        if(points[vs.channel!]! > maxpoints) {
          maxpoints = points[vs.channel!]!;
          bestChannel = vs.channel!;
        }
      }
    }

    if(maxpoints < 2) {
      if(Bot().config.autoConnectVoicePersist) {
        final botChannelId = botState?.channelId;
        final channelId = Snowflake(Bot().config[guild.id].defaultVoiceChannelId);

        if(botChannelId != channelId) connectTo(channelId, true);
      } else {
        disconnect();
      }
      
      return;
    }

    final channel = await Bot().client.channels.get(bestChannel!.id) as GuildVoiceChannel;
    
    if(channel.id != botState?.channelId) connectTo(channel.id);
  }
}