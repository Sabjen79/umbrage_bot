import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/conversation/conversation.dart';
import 'package:umbrage_bot/bot/lexicon/events/lexicon_event.dart';
import 'package:umbrage_bot/bot/lexicon/lexicon.dart';
import 'package:umbrage_bot/bot/lexicon/variables/predefined/lexicon_everyone_variable.dart';
import 'package:umbrage_bot/bot/lexicon/variables/predefined/lexicon_mention_variable.dart';

class LexiconEveryoneEvent extends LexiconEvent<MessageCreateEvent> {
  LexiconMentionVariable mentionVariable = LexiconMentionVariable("Mentions the user that sent the message.");

  LexiconEveryoneEvent(Lexicon l) :
  super(l, "mention_everyone", "Everyone Mention Event", "When someone mentions @everyone or @here, the bot will reply.") {
    variables.addAll([
      mentionVariable,
      LexiconEveryoneVariable()
    ]);
  }

  @override
  Future<bool> validateEvent(MessageCreateEvent event) async {
    var user = (await event.member!.get()).user!;
    var content = event.message.content;
    if(!content.contains("@everyone") && !content.contains("@here")) return false;
      
    mentionVariable.setSecondaryValue(user);

    return true;
  }

  @override
  Future<Conversation> buildConversation(MessageCreateEvent event) async {
    return Conversation(
      content: getPhrase(),
      channel: event.message.channel,
      replyMessage: event.message,
      isReply: true
    );
  }

}