import 'package:material_symbols_icons/symbols.dart';
import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/lexicon/conversation/conversation.dart';
import 'package:umbrage_bot/bot/lexicon/events/lexicon_event.dart';
import 'package:umbrage_bot/bot/lexicon/lexicon.dart';
import 'package:umbrage_bot/bot/lexicon/variables/predefined/lexicon_channel_mention_variable.dart';
import 'package:umbrage_bot/bot/lexicon/variables/predefined/lexicon_everyone_variable.dart';
import 'package:umbrage_bot/bot/lexicon/variables/predefined/lexicon_member_name_variable.dart';
import 'package:umbrage_bot/bot/lexicon/variables/predefined/lexicon_mention_variable.dart';
import 'package:umbrage_bot/bot/util/member_name.dart';

class LexiconVoiceJoinEvent extends LexiconEvent<VoiceStateUpdateEvent> {
  LexiconMemberNameVariable memberNameVariable = LexiconMemberNameVariable("Gets the name of the user that joined the voice channel.");
  LexiconMentionVariable mentionVariable = LexiconMentionVariable("Mentions the user that joined the voice channel.");
  LexiconChannelMentionVariable channelMentionVariable = LexiconChannelMentionVariable("Mentions the channel that the user joined.");

  LexiconVoiceJoinEvent(Lexicon l) :
  super(l, Symbols.call, "voice_join", "Voice Join Event", "When someone enters the voice channel that the bot is in, it will respond.") {
    variables.addAll([
      memberNameVariable,
      mentionVariable,
      LexiconEveryoneVariable(),
      channelMentionVariable
    ]);
  }

  @override
  Future<bool> validateEvent(VoiceStateUpdateEvent event) async {
    var textChannel = (await event.state.guild?.get())?.systemChannel;

    if(textChannel == null || event.state.member == null) return false;
    if(event.state.channelId == null || event.oldState!.channelId != null) return false;
    if(event.state.channelId != event.state.guild?.voiceStates[Bot().user.id]?.channelId) return false;
      
    memberNameVariable.setSecondaryValue(event.state.member!.effectiveName);
    mentionVariable.setSecondaryValue(event.state.userId);
    channelMentionVariable.setSecondaryValue(event.state.channelId!);

    return true;
  }

  @override
  Future<Conversation> buildConversation(VoiceStateUpdateEvent event) async {
    return Conversation(
      messages: getRandomMessageList(),
      channel: await Bot().config[event.state.guildId!].mainMessageChannel as PartialTextChannel,
      user: (await event.state.member!.get()).user
    );
  }
}