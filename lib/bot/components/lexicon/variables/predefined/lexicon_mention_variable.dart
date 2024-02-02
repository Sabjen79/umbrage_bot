import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/components/lexicon/variables/lexicon_variable.dart';
import 'package:umbrage_bot/bot/components/lexicon/variables/lexicon_variable_secondary_value_mixin.dart';

class LexiconMentionVariable extends LexiconVariable with LexiconVariableSecondaryValueMixin<PartialUser> {
  LexiconMentionVariable(String description) : super("mention", "Mention", description, 0xFF2880BA);
    
  @override
  String getValue() {
    return "<@${getSecondaryValue().id.toString()}>";
  }
}