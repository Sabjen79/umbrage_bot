import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/lexicon/variables/lexicon_variable.dart';
import 'package:umbrage_bot/bot/lexicon/variables/lexicon_variable_secondary_value_mixin.dart';

class LexiconMentionVariable extends LexiconVariable with LexiconVariableSecondaryValueMixin<Snowflake> {
  LexiconMentionVariable(String description) : super("mention", "Mention", description, 0xFF2880BA);
    
  @override
  String getValue() {
    if(getSecondaryValue() == null) return "";
    
    return "<@${getSecondaryValue().toString()}>";
  }
}