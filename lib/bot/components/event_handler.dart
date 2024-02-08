import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/bot.dart';

class EventHandler {
  final NyxxGateway client;
  Map<Snowflake, Map<Snowflake, VoiceState>> voiceStates = {};

  EventHandler(this.client) {
    client.onMessageCreate.listen(onMessageCreate);
    client.onVoiceStateUpdate.listen(onVoiceStateUpdate);

    client.listGuilds().then((list) async {
      for(var g in list) {
        voiceStates[g.id] = Map.from(g.voiceStates);
      }
    });
    
  }

  void onMessageCreate(MessageCreateEvent event) async {
    if(event.member == null) return;
    var user = (await event.member!.get()).user!;
    if(user == Bot().user) return;

    Bot().lexicon.handleEvent(event);
  }

  void onVoiceStateUpdate(VoiceStateUpdateEvent event) async {
    var oldState = voiceStates[event.state.guildId]?[event.state.userId];
    voiceStates[event.state.guildId!] = Map.from(client.guilds[event.state.guildId!].voiceStates);

    if(oldState == null || event.state.member == null || event.state.user == Bot().user) return;

    Bot().lexicon.handleEvent(VoiceStateUpdateEventFixed(gateway: event.gateway, oldState: oldState, state: event.state));
  }
}

// The field oldState is the same as state in VoiceStateUpdateEvent, so it needs to be manually created
class VoiceStateUpdateEventFixed extends VoiceStateUpdateEvent { 
  VoiceStateUpdateEventFixed({required super.gateway, required super.oldState, required super.state});
}