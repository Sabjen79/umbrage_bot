import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/lexicon/events/lexicon_event.dart';
import 'package:umbrage_bot/bot/lexicon/lexicon.dart';
import 'package:umbrage_bot/bot/lexicon/variables/predefined/lexicon_everyone_variable.dart';
import 'package:umbrage_bot/bot/lexicon/variables/predefined/lexicon_mention_variable.dart';

class LexiconMentionEvent extends LexiconEvent {
  LexiconMentionVariable mentionVariable = LexiconMentionVariable("Mentions the user that sent the message.");

  LexiconMentionEvent(Lexicon l) :
  super(l, "mention_bot", "Mention Event", "When someone mentions the bot's name, it will sometimes reply back.") {
    variables.addAll([
      mentionVariable,
      LexiconEveryoneVariable()
    ]);

    Bot().client.onMessageCreate.listen((event) async { 
      if(event.member == null) return; // TO-DO: Implement a simple Validator

      var user = (await event.member!.get()).user!;
      if(user == Bot().user || !event.message.mentions.contains(Bot().user)) return;
      
      mentionVariable.setSecondaryValue(user);
      
      await event.message.channel.sendMessage(MessageBuilder( // TO-DO: Implement a GOOD Message Builder
        content: getPhrase(),
        replyId: event.message.id
      ));
    });
  }
}