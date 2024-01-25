import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/components/lexicon/variables/lexicon_variable.dart';

class LexiconMentionVariable extends LexiconVariable {
  Snowflake? mention;

  LexiconMentionVariable(String description) : super("mention", "Mention", description);
    
  @override
  String computeVariable() {
    if(mention == null) return "";
    return "<@${mention.toString()}>";
  }
}