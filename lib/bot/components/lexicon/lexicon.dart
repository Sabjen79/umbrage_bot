import 'package:umbrage_bot/bot/components/lexicon/events/lexicon_event.dart';
import 'package:umbrage_bot/bot/components/lexicon/events/lexicon_mention_event.dart';
import 'package:umbrage_bot/bot/components/lexicon/variables/lexicon_custom_variable.dart';
import 'package:umbrage_bot/bot/util/bot_files.dart';

class Lexicon {
  final List<LexiconCustomVariable> customVariables = [];

  // Always remember to include all events in getAllEvents()!!!
  late final LexiconMentionEvent mentionEvent;

  // Constructor
  Lexicon() {
    final BotFiles files = BotFiles();

    for(var file in files.getDir("lexicon/variables").listSync()) {
      customVariables.add(
        files.loadLexiconVariable(
          file.path.split(RegExp(r'[/\\]+')).last // Splits path by '/' and '\'
        )
      );
    }

    mentionEvent = LexiconMentionEvent(this, files.loadLexiconEventPhrases("mention_bot.txt"));
  }
  //

  // Event Getters
  LexiconEvent? getEvent<T extends LexiconEvent>() {
    if(T.toString() == "LexiconEvent") throw Exception("Lexicon.getEvent() should be called with a generic type included");

    for(var event in getAllEvents()) {
      if(event is T) {
        return event;
      }
    }
    return null;
  }

  List<LexiconEvent> getAllEvents() {
    return <LexiconEvent>[
      mentionEvent
    ];
  }
  //

  void deleteCustomVariable(LexiconCustomVariable variable) {
    if(!customVariables.remove(variable)) return;

    BotFiles().deleteFile("lexicon/variables/${variable.token}.txt");
  }
}