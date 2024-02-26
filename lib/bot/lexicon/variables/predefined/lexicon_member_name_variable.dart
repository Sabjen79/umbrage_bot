import 'package:umbrage_bot/bot/lexicon/variables/lexicon_variable.dart';
import 'package:umbrage_bot/bot/lexicon/variables/lexicon_variable_secondary_value_mixin.dart';

class LexiconMemberNameVariable extends LexiconVariable with LexiconVariableSecondaryValueMixin<String> {
  LexiconMemberNameVariable(String description) : super("member_name", "Member Name", description, 0xFFFF4242);
    
  @override
  String getValue() {
    if(getSecondaryValue() == null) return "";
    
    return getSecondaryValue()!;
  }
}