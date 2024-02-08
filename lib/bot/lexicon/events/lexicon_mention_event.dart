import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/conversation/conversation.dart';
import 'package:umbrage_bot/bot/lexicon/events/lexicon_event.dart';
import 'package:umbrage_bot/bot/lexicon/lexicon.dart';
import 'package:umbrage_bot/bot/lexicon/variables/predefined/lexicon_everyone_variable.dart';
import 'package:umbrage_bot/bot/lexicon/variables/predefined/lexicon_mention_variable.dart';

class LexiconMentionEvent extends LexiconEvent<MessageCreateEvent> {
  LexiconMentionVariable mentionVariable = LexiconMentionVariable("Mentions the user that sent the message.");

  LexiconMentionEvent(Lexicon l) :
  super(l, "mention_bot", "Mention Event", "When someone mentions the bot's name, it will sometimes reply back.") {
    variables.addAll([
      mentionVariable,
      LexiconEveryoneVariable()
    ]);
  }

  @override
  Future<bool> validateEvent(MessageCreateEvent event) async {
    var user = (await event.member!.get()).user!;
    if(!event.message.mentions.contains(Bot().user)) return false;
      
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