import 'package:umbrage_bot/bot/components/lexicon/variables/lexicon_variable.dart';

class LexiconEveryoneVariable extends LexiconVariable {
  LexiconEveryoneVariable() : super("everyone", "Mention Everyone", "Mentions @everyone to notify all users", 0xFFFFC211);

  @override
  String getValue() {
    return "@everyone";
  }
}