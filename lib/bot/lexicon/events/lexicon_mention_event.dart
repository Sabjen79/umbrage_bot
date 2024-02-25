import 'package:material_symbols_icons/symbols.dart';
import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/lexicon/conversation/conversation.dart';
import 'package:umbrage_bot/bot/lexicon/events/lexicon_event.dart';
import 'package:umbrage_bot/bot/lexicon/lexicon.dart';
import 'package:umbrage_bot/bot/lexicon/variables/predefined/lexicon_everyone_variable.dart';
import 'package:umbrage_bot/bot/lexicon/variables/predefined/lexicon_mention_variable.dart';

class LexiconMentionEvent extends LexiconEvent<MessageCreateEvent> {
  LexiconMentionVariable mentionVariable = LexiconMentionVariable("Mentions the user that sent the message.");

  LexiconMentionEvent(Lexicon l) :
  super(l, Symbols.alternate_email, "mention_bot", "Mention Event", "When someone mentions the bot's name, it will sometimes reply back.") {
    variables.addAll([
      mentionVariable,
      LexiconEveryoneVariable()
    ]);
  }

  @override
  Future<bool> validateEvent(MessageCreateEvent event) async {
    mentionVariable.setSecondaryValue(event.member!.id);

    if(!event.message.mentions.contains(Bot().user) &&
     !event.message.content.toLowerCase().contains(Bot().user.username.toLowerCase())) return false;

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