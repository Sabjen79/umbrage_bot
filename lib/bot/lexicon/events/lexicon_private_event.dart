import 'package:material_symbols_icons/symbols.dart';
import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/lexicon/conversation/conversation.dart';
import 'package:umbrage_bot/bot/lexicon/events/lexicon_event.dart';
import 'package:umbrage_bot/bot/lexicon/lexicon.dart';
import 'package:umbrage_bot/bot/lexicon/variables/predefined/lexicon_mention_variable.dart';

class LexiconPrivateEvent extends LexiconEvent<PrivateMessageEvent> {
  LexiconMentionVariable mentionVariable = LexiconMentionVariable("Mentions the user that sent the message.");

  LexiconPrivateEvent(Lexicon l) :
  super(l, Symbols.lock, "private", "Private Message Event", "When someone sends a private message to the bot, it will respond.") {
    variables.addAll([
      mentionVariable,
    ]);
  }

  @override
  Future<bool> validateEvent(PrivateMessageEvent event) async {
    var user = event.message.author as User;
    if(user.id == Bot().user.id) return false;
      
    mentionVariable.setSecondaryValue(user.id);

    return true;
  }

  @override
  Future<Conversation> buildConversation(PrivateMessageEvent event) async {
    return Conversation(
      messages: getRandomMessageList(),
      channel: event.message.channel,
      replyMessage: event.message,
      user: event.message.author as User,
      isReply: true
    );
  }

}

class PrivateMessageEvent extends DispatchEvent {
  final Message message;
  PrivateMessageEvent(this.message) : super(gateway: Bot().client.gateway);
}