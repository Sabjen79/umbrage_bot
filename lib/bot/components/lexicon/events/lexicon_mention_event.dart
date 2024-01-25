import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/components/lexicon/events/lexicon_event.dart';
import 'package:umbrage_bot/bot/components/lexicon/variables/lexicon_everyone_variable.dart';
import 'package:umbrage_bot/bot/components/lexicon/variables/lexicon_mention_variable.dart';

class LexiconMentionEvent extends LexiconEvent {
  LexiconMentionVariable mentionVariable = LexiconMentionVariable("Mentions the user that sent the message.");

  LexiconMentionEvent(List<String> phrases) : super(
    "mention_bot", 
    "Mention Phrases", 
    "When someone mentions the bot's name, it will sometimes reply back.",
    phrases
  ) {
    variables.addAll([
      mentionVariable,
      LexiconEveryoneVariable()
    ]);

    Bot().client.onMessageCreate.listen((event) { 

    });
  }
}