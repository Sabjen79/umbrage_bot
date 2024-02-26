import 'package:umbrage_bot/bot/lexicon/variables/lexicon_variable.dart';

class LexiconEveryoneVariable extends LexiconVariable {
  LexiconEveryoneVariable() : super("everyone", "Mention Everyone", "Mentions @everyone to notify all users", 0xFFFFEA00);

  @override
  String getValue() {
    return "@everyone";
  }
}