import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/conversation/conversation_builder.dart';
import 'package:umbrage_bot/bot/conversation/conversation_delimiters.dart';
import 'package:umbrage_bot/bot/lexicon/events/lexicon_event.dart';
import 'package:umbrage_bot/bot/lexicon/lexicon.dart';
import 'package:umbrage_bot/bot/lexicon/variables/predefined/lexicon_everyone_variable.dart';
import 'package:umbrage_bot/bot/lexicon/variables/predefined/lexicon_mention_variable.dart';

class LexiconMentionEvent extends LexiconEvent<MessageCreateEvent> {
  LexiconMentionVariable mentionVariable = LexiconMentionVariable("Mentions the user that sent the message.");

  LexiconMentionEvent(Lexicon l) :
  super(l, Bot().client.onMessageCreate, "mention_bot", "Mention Event", "When someone mentions the bot's name, it will sometimes reply back.") {
    variables.addAll([
      mentionVariable,
      LexiconEveryoneVariable()
    ]);

    delimiters.addAll(ConversationDelimiters.values);
  }

  @override
  Future<bool> validateEvent(MessageCreateEvent event) async {
    if(event.member == null) return false;

    var user = (await event.member!.get()).user!;
    if(user == Bot().user || !event.message.mentions.contains(Bot().user)) return false;
      
    mentionVariable.setSecondaryValue(user);

    return true;
  }

  @override
  Future<void> runEvent(MessageCreateEvent event) async {
    ConversationBuilder(
      content: getPhrase(),
      channel: event.message.channel,
      replyMessage: event.message
    ).sendMessage();
  }
}