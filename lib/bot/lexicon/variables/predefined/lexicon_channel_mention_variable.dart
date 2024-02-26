import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/lexicon/variables/lexicon_variable.dart';
import 'package:umbrage_bot/bot/lexicon/variables/lexicon_variable_secondary_value_mixin.dart';

class LexiconChannelMentionVariable extends LexiconVariable with LexiconVariableSecondaryValueMixin<Snowflake> {
  LexiconChannelMentionVariable(String description) : super("channel_mention", "Channel Mention", description, 0xFF7842FF);
    
  @override
  String getValue() {
    if(getSecondaryValue() == null) return "";
    
    return "<#${getSecondaryValue().toString()}>";
  }
}