import 'package:umbrage_bot/bot/components/lexicon/variables/lexicon_variable.dart';

class LexiconEveryoneVariable extends LexiconVariable {
  LexiconEveryoneVariable() : super("everyone", "Mention everyone", "Appends @everyone to the message to notify all users", 0xFFAAAAAA);

  @override
  String getValue() {
    return "@everyone";
  }
}