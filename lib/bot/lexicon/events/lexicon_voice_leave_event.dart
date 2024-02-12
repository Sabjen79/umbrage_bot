import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/conversation/conversation.dart';
import 'package:umbrage_bot/bot/lexicon/events/lexicon_event.dart';
import 'package:umbrage_bot/bot/lexicon/lexicon.dart';
import 'package:umbrage_bot/bot/lexicon/variables/predefined/lexicon_everyone_variable.dart';
import 'package:umbrage_bot/bot/lexicon/variables/predefined/lexicon_mention_variable.dart';

class LexiconVoiceLeaveEvent extends LexiconEvent<VoiceStateUpdateEvent> {
  LexiconMentionVariable mentionVariable = LexiconMentionVariable("Mentions the user that joined the voice channel.");

  LexiconVoiceLeaveEvent(Lexicon l) :
  super(l, "voice_leave", "Voice Leave Event", "When someone disconnects from a voice channel, the event will trigger.") {
    variables.addAll([
      mentionVariable,
      LexiconEveryoneVariable()
    ]);
  }

  @override
  Future<bool> validateEvent(VoiceStateUpdateEvent event) async {
    var textChannel = (await event.state.guild?.get())?.systemChannel;
    var user = (await event.state.member?.get())?.user;

    if(textChannel == null || user == null) return false;
    if(event.state.channelId != null || event.oldState!.channelId == null) return false;
      
    mentionVariable.setSecondaryValue(user);

    return true;
  }

  @override
  Future<Conversation> buildConversation(VoiceStateUpdateEvent event) async {
    return Conversation(
      content: getPhrase(),
      channel: (await event.state.guild!.get()).systemChannel!,
      user: (await event.state.member!.get()).user
    );
  }
}