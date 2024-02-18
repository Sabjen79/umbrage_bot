import 'package:material_symbols_icons/symbols.dart';
import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/conversation/conversation.dart';
import 'package:umbrage_bot/bot/lexicon/events/lexicon_event.dart';
import 'package:umbrage_bot/bot/lexicon/lexicon.dart';
import 'package:umbrage_bot/bot/lexicon/variables/predefined/lexicon_everyone_variable.dart';
import 'package:umbrage_bot/bot/lexicon/variables/predefined/lexicon_mention_variable.dart';

class LexiconMuteKickEvent extends LexiconEvent<MessageCreateEvent> {
  LexiconMentionVariable mentionVariable = LexiconMentionVariable("Mentions the user that was kicked.");

  LexiconMuteKickEvent(Lexicon l) :
  super(l, Symbols.bomb, "mute_kick", "Mute-Nuke Event", "When someone is disconnected by the nuke extension, the bot may send a message.") {
    variables.addAll([
      mentionVariable,
      LexiconEveryoneVariable()
    ]);
  }

  @override
  Future<bool> validateEvent(MessageCreateEvent event) async {
    // TODO: validateEvent
    return false;
  }

  @override
  Future<Conversation> buildConversation(MessageCreateEvent event) async {
    return Conversation(
      content: getPhrase(),
      channel: event.message.channel,
      user: mentionVariable.getSecondaryValue()
    );
  }
}