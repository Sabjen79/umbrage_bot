import 'package:material_symbols_icons/symbols.dart';
import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/lexicon/conversation/conversation.dart';
import 'package:umbrage_bot/bot/lexicon/events/lexicon_event.dart';
import 'package:umbrage_bot/bot/lexicon/lexicon.dart';
import 'package:umbrage_bot/bot/lexicon/variables/predefined/lexicon_everyone_variable.dart';
import 'package:umbrage_bot/bot/lexicon/variables/predefined/lexicon_mention_variable.dart';

class LexiconImageEvent extends LexiconEvent<MessageCreateEvent> {
  LexiconMentionVariable mentionVariable = LexiconMentionVariable("Mentions the user that sent the message.");

  LexiconImageEvent(Lexicon l) :
  super(l, Symbols.image, "image", "Image Event", "When someone sends a message or video, the bot will respond") {
    variables.addAll([
      mentionVariable,
      LexiconEveryoneVariable()
    ]);
  }

  @override
  Future<bool> validateEvent(MessageCreateEvent event) async {
    mentionVariable.setSecondaryValue(event.member!.id);

    final list = event.message.attachments;

    for(final item in list) {
      if(item.contentType != null && (item.contentType!.contains("image") || item.contentType!.contains("video"))) return true;
    }

    if(event.message.content.contains("http") && event.message.content.contains("gif")) return true;
    if(event.message.content.startsWith("https://cdn.discordapp.com/attachments/")) return true;

    return false;
  }

  @override
  Future<Conversation> buildConversation(MessageCreateEvent event) async {
    return Conversation(
      content: getPhrase(),
      channel: event.message.channel,
      replyMessage: event.message,
      user: event.message.author as User,
      isReply: true
    );
  }
}