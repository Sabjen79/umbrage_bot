import 'dart:async';

import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/lexicon/events/lexicon_mute_kick_event.dart';
import 'package:umbrage_bot/bot/lexicon/events/lexicon_voice_leave_event.dart';

class MuteKick {
  final Map<Member, Timer?> _timers = {};

  MuteKick();

  void handleEvent(VoiceStateUpdateEvent event) async {
    if(!Bot().config.muteKickEnable || event.state.guild == null) return;

    final member = event.state.member!;
    
    var status = _getStatus(event.state, event.oldState!);

    if(status == 0) {
      _timers[member]?.cancel();
    } else if(status == 1) {
      _timers[member] = Timer(Duration(milliseconds: Bot().config.muteKickDuration), () {
        _disconnectMember(member);
      });
    }
  }

  // -1 for no valid change
  // 0 for unmute
  // 1 for mute
  int _getStatus(VoiceState state, VoiceState oldState) {
    final onlyMute = Bot().config.muteKickOnlyMute;
    final isMuted = onlyMute ? state.isSelfMuted && !state.isSelfDeafened : state.isSelfMuted;
    final wasMuted = onlyMute ? oldState.isSelfMuted && !oldState.isSelfDeafened : oldState.isSelfMuted;

    if(isMuted && !wasMuted) return 1;
    if(isMuted && oldState.channel == null) return 1; // Special case: When someone joins a voice channel already muted
    if(!isMuted && wasMuted) return 0;
    return -1;
  }

  void _disconnectMember(Member member) async {
    final guild = await Bot().client.guilds[member.manager.guildId].get();
    final voiceState = guild.voiceStates[member.id];

    if(voiceState == null || voiceState.channel == null) return;
    if(Bot().config.muteKickIgnoreAfk && guild.afkChannelId == voiceState.channelId) return;

    final voiceLeaveEvent = Bot().lexicon.getLexiconEvent<LexiconVoiceLeaveEvent>() as LexiconVoiceLeaveEvent;

    // Disables the future voice leave event that the disconnection will trigger
    voiceLeaveEvent.disableFutureEvent = true;

    Bot().lexicon.handleEvent(MuteKickEvent(member, voiceState.channelId!), guild.id);

    await member.update(MemberUpdateBuilder(
      voiceChannelId: null
    ));
  }
}