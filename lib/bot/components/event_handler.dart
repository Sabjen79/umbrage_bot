import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/bot.dart';

class EventHandler {
  final NyxxGateway client;
  Map<Snowflake, Map<Snowflake, VoiceState>> voiceStates = {};

  EventHandler(this.client) {
    client.onMessageCreate.listen(onMessageCreate);
    client.onVoiceStateUpdate.listen(onVoiceStateUpdate);

    client.listGuilds().then((list) async {
      for(final g in list) {
        voiceStates[g.id] = Map.from(g.voiceStates);

        client.updateVoiceState(g.id, GatewayVoiceStateBuilder(
          channelId: null,
          isMuted: false,
          isDeafened: false
        ));
      }
    });
  }

  void onMessageCreate(MessageCreateEvent event) async {
    if(event.member == null) return;
    final user = (await event.member!.get()).user!;
    if(user == Bot().user) return;

    if(event.guildId != null && await Bot().voiceManager[event.guildId!].music.handleEvent(event)) return;

    await Bot().lexicon.handleEvent(event);
  }

  void onVoiceStateUpdate(VoiceStateUpdateEvent event) async {
    final oldState = voiceStates[event.state.guildId]?[event.state.userId];
    voiceStates[event.state.guildId!] = Map.from(client.guilds[event.state.guildId!].voiceStates);

    if(event.state.user == Bot().user) {
      _botStateEvents(event);
    }

    if(event.state.member == null || event.state.user == Bot().user) return;
    
    Bot().voiceManager[event.state.guildId!].handleEvent(event);

    if(oldState == null) return;
    final newEvent = VoiceStateUpdateEvent(gateway: event.gateway, oldState: oldState, state: event.state);

    Bot().lexicon.handleEvent(newEvent);
  }

  
  void _botStateEvents(VoiceStateUpdateEvent event) {
    // When the bot disconnects from a voice channel, the player stops.
    // This is to ensure the player starts again when reconnecting.
    if(event.state.channel != null) {
      Bot().voiceManager[event.state.guildId!].music.replayCurrentTrack();
    }

    // Some would try to server mute/deafen the bot, too bad it has admin priviledges ;)
    if(event.state.isServerMuted || event.state.isServerDeafened) {
      event.state.guild?.members.update(Bot().user.id, MemberUpdateBuilder(isDeaf: false, isMute: false));
    }
  }
}