import 'package:material_symbols_icons/symbols.dart';
import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/lexicon/conversation/conversation.dart';
import 'package:umbrage_bot/bot/lexicon/events/lexicon_event.dart';
import 'package:umbrage_bot/bot/lexicon/lexicon.dart';
import 'package:umbrage_bot/bot/lexicon/variables/predefined/lexicon_channel_mention_variable.dart';
import 'package:umbrage_bot/bot/lexicon/variables/predefined/lexicon_everyone_variable.dart';
import 'package:umbrage_bot/bot/lexicon/variables/predefined/lexicon_member_name_variable.dart';
import 'package:umbrage_bot/bot/lexicon/variables/predefined/lexicon_mention_variable.dart';
import 'package:umbrage_bot/bot/util/member_name.dart';

class LexiconMuteKickEvent extends LexiconEvent<MuteKickEvent> {
  LexiconMemberNameVariable memberNameVariable = LexiconMemberNameVariable("Gets the name of the member that got kicked.");
  LexiconMentionVariable mentionVariable = LexiconMentionVariable("Mentions the user that was kicked.");
  LexiconChannelMentionVariable channelMentionVariable = LexiconChannelMentionVariable("Mentions the voice channel from which the member was kicked.");

  LexiconMuteKickEvent(Lexicon l) :
  super(l, Symbols.bomb, "mute_kick", "Mute-Nuke Event", "When someone is disconnected by the nuke extension, the bot may send a message.") {
    variables.addAll([
      memberNameVariable,
      mentionVariable,
      LexiconEveryoneVariable()
    ]);
  }

  @override
  Future<bool> validateEvent(MuteKickEvent event) async {
    memberNameVariable.setSecondaryValue(event.member.effectiveName);
    mentionVariable.setSecondaryValue(event.member.id);
    channelMentionVariable.setSecondaryValue(event.channelId);

    return true;
  }

  @override
  Future<Conversation> buildConversation(MuteKickEvent event) async {
    return Conversation(
      messages: getRandomMessageList(),
      channel: await Bot().config[event.guildId].mainMessageChannel as PartialTextChannel,
      user: event.member.user!
    );
  }
}

class MuteKickEvent extends DispatchEvent {
  final Member member;
  final Snowflake guildId;
  final Snowflake channelId;

  MuteKickEvent(this.member, this.channelId) :
    guildId = member.manager.guildId,
    super(gateway: Bot().client.gateway);
}