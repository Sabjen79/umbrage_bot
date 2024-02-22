import 'package:material_symbols_icons/symbols.dart';
import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/lexicon/conversation/conversation.dart';
import 'package:umbrage_bot/bot/lexicon/events/lexicon_event.dart';
import 'package:umbrage_bot/bot/lexicon/lexicon.dart';
import 'package:umbrage_bot/bot/lexicon/variables/predefined/lexicon_everyone_variable.dart';
import 'package:umbrage_bot/bot/lexicon/variables/predefined/lexicon_mention_variable.dart';

class LexiconMuteKickEvent extends LexiconEvent<MuteKickEvent> {
  LexiconMentionVariable mentionVariable = LexiconMentionVariable("Mentions the user that was kicked.");

  LexiconMuteKickEvent(Lexicon l) :
  super(l, Symbols.bomb, "mute_kick", "Mute-Nuke Event", "When someone is disconnected by the nuke extension, the bot may send a message.") {
    variables.addAll([
      mentionVariable,
      LexiconEveryoneVariable()
    ]);
  }

  @override
  Future<bool> validateEvent(MuteKickEvent event) async {
    mentionVariable.setSecondaryValue(event.member.id);

    return true;
  }

  @override
  Future<Conversation> buildConversation(MuteKickEvent event) async {
    return Conversation(
      content: getPhrase(),
      channel: await Bot().config[event.guildId].mainMessageChannel as PartialTextChannel,
      user: event.member.user!
    );
  }
}

class MuteKickEvent extends DispatchEvent {
  final Member member;
  final Snowflake guildId;

  MuteKickEvent(this.member) :
    guildId = member.manager.guildId,
    super(gateway: Bot().client.gateway);
}