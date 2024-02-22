import 'dart:async';

import 'package:material_symbols_icons/symbols.dart';
import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/lexicon/conversation/conversation.dart';
import 'package:umbrage_bot/bot/lexicon/events/lexicon_event.dart';
import 'package:umbrage_bot/bot/lexicon/lexicon.dart';
import 'package:umbrage_bot/bot/lexicon/variables/predefined/lexicon_everyone_variable.dart';

class LexiconAnnounceEvent extends LexiconEvent<AnnounceEvent> {

  LexiconAnnounceEvent(Lexicon l) :
  super(l, Symbols.event_upcoming, "announce", "Announce Event", "Every 10 minutes, the bot will try to send a message to the main text channel. Consider a high cooldown and low chance to not make the bot spammy.") {
    variables.addAll([
      LexiconEveryoneVariable()
    ]);

    Timer.periodic(const Duration(minutes: 10), (timer) async {
      for(final g in Bot().guildList) {
        handleEvent(AnnounceEvent(g.id));
      }
    });
  }

  @override
  Future<bool> validateEvent(AnnounceEvent event) async {
    return true;
  }

  @override
  Future<Conversation> buildConversation(AnnounceEvent event) async {
    return Conversation(
      content: getPhrase(),
      channel: await Bot().config[event.guildId].mainMessageChannel as PartialTextChannel,
    );
  }
}

class AnnounceEvent extends DispatchEvent {
  final Snowflake guildId;

  AnnounceEvent(this.guildId) : super(gateway: Bot().client.gateway);
}