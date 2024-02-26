import 'package:material_symbols_icons/symbols.dart';
import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/lexicon/conversation/conversation.dart';
import 'package:umbrage_bot/bot/lexicon/events/lexicon_event.dart';
import 'package:umbrage_bot/bot/lexicon/lexicon.dart';
import 'package:umbrage_bot/bot/lexicon/variables/predefined/lexicon_channel_mention_variable.dart';
import 'package:umbrage_bot/bot/lexicon/variables/predefined/lexicon_everyone_variable.dart';
import 'package:umbrage_bot/bot/lexicon/variables/predefined/lexicon_member_name_variable.dart';
import 'package:umbrage_bot/bot/lexicon/variables/predefined/lexicon_mention_variable.dart';
import 'package:umbrage_bot/bot/util/member_name.dart';

class LexiconEveryoneEvent extends LexiconEvent<MessageCreateEvent> {
  LexiconMemberNameVariable memberNameVariable = LexiconMemberNameVariable("Gets the name of the member that sent the message.");
  LexiconMentionVariable mentionVariable = LexiconMentionVariable("Mentions the user that sent the message.");
  LexiconChannelMentionVariable channelMentionVariable = LexiconChannelMentionVariable("Mentions the channel that the message was sent in.");

  LexiconEveryoneEvent(Lexicon l) :
  super(l, Symbols.groups, "mention_everyone", "Everyone Mention Event", "When someone mentions @everyone or @here, the bot will reply.") {
    variables.addAll([
      memberNameVariable,
      mentionVariable,
      LexiconEveryoneVariable(),
      channelMentionVariable
    ]);
  }

  @override
  Future<bool> validateEvent(MessageCreateEvent event) async {
    var content = event.message.content;
    if(!content.contains("@everyone") && !content.contains("@here")) return false;
    
    memberNameVariable.setSecondaryValue((await event.member!.get()).effectiveName);
    mentionVariable.setSecondaryValue(event.member!.id);
    channelMentionVariable.setSecondaryValue(event.message.channelId);

    return true;
  }

  @override
  Future<Conversation> buildConversation(MessageCreateEvent event) async {
    return Conversation(
      messages: getRandomMessageList(),
      channel: event.message.channel,
      replyMessage: event.message,
      user: event.message.author as User,
      isReply: true
    );
  }

}