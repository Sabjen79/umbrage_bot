import 'package:flutter/material.dart';
import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/conversation/conversation.dart';
import 'package:umbrage_bot/bot/conversation/conversation_delimiters.dart';
import 'package:umbrage_bot/bot/lexicon/events/lexicon_announce_event.dart';
import 'package:umbrage_bot/bot/lexicon/events/lexicon_event.dart';
import 'package:umbrage_bot/bot/lexicon/events/lexicon_everyone_event.dart';
import 'package:umbrage_bot/bot/lexicon/events/lexicon_image_event.dart';
import 'package:umbrage_bot/bot/lexicon/events/lexicon_mention_event.dart';
import 'package:umbrage_bot/bot/lexicon/events/lexicon_mute_kick_event.dart';
import 'package:umbrage_bot/bot/lexicon/events/lexicon_private_event.dart';
import 'package:umbrage_bot/bot/lexicon/events/lexicon_voice_join_event.dart';
import 'package:umbrage_bot/bot/lexicon/events/lexicon_voice_leave_event.dart';
import 'package:umbrage_bot/bot/lexicon/variables/lexicon_custom_variable.dart';
import 'package:umbrage_bot/bot/util/bot_files.dart';
import 'package:umbrage_bot/bot/util/result.dart';
import 'package:umbrage_bot/ui/main_menu/lexicon/custom_variables/lexicon_variable_window.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_menu_router.dart';

class Lexicon with ChangeNotifier {
  final Map<Snowflake, Conversation?> conversations = {}; // One conversation per text channel!
  final List<LexiconCustomVariable> _customVariables = [];
  final List<LexiconEvent> _events = [];

  // Constructor
  Lexicon() {
    final BotFiles files = BotFiles();

    _events.addAll([
      LexiconAnnounceEvent(this),
      LexiconMentionEvent(this),
      LexiconEveryoneEvent(this),
      LexiconImageEvent(this),
      LexiconPrivateEvent(this),
      LexiconVoiceJoinEvent(this),
      LexiconVoiceLeaveEvent(this),
      LexiconMuteKickEvent(this)
    ]);

    for(var file in files.getDir("lexicon/variables").listSync()) {
      _customVariables.add(
        LexiconCustomVariable.fromJson(file.path.split(RegExp(r'[/\\]+')).last) // Splits path by '/' and '\'
      );
    }
  }
  //

  Future<bool> handleEvent(DispatchEvent dispatchEvent) async {
    for(var event in _events) {
      if(await event.handleEvent(dispatchEvent)) {
        return true;
      }
    }

    if(dispatchEvent is MessageCreateEvent) {
      conversations[dispatchEvent.message.channelId]?.advance(dispatchEvent);
      return true;
    }

    if(dispatchEvent is PrivateMessageEvent) {
      conversations[dispatchEvent.message.channelId]?.advancePrivate(dispatchEvent);
      return true;
    }

    return false;
  }

  // Events
  List<LexiconEvent> get events => _events;

  LexiconEvent getLexiconEvent<T extends LexiconEvent>() {
    if(T.toString() == "LexiconEvent") throw Exception("Lexicon.getEvent() should be called with a generic type included");

    for(var event in _events) {
      if(event is T) {
        return event;
      }
    }

    throw Exception("Event does not exist.");
  }

  Result<LexiconEvent> updateLexiconEvent(String filename, bool enabled, double chance, int cooldown, List<String> phrases) {
    if(enabled && chance == 0) return Result.failure("Chance is 0. Disable the event instead.");

    for(var p in phrases) {
      if(p.replaceAll(" ", "").isEmpty) return Result.failure("One or more phrases are empty.");
    }

    for(var event in _events) {
      if(event.filename == filename) {
        event.enabled = enabled;
        event.cooldown = cooldown;
        event.chance = chance;
        event.phrases..clear()..addAll(phrases);

        event.saveToJson();

        return Result.success(event);
      }
    }

    return Result.failure("Event does not exist."); // This should not ever happen!
  }

  // Custom Variables
  List<LexiconCustomVariable> get customVariables => _customVariables;

  Result<LexiconCustomVariable> createCustomVariable(String keyword, String name, String description, int color, List<String> words) {
    var result = _createVariable(keyword, name, description, color, words);

    if(result.isSuccess) {
      _customVariables.add(result.value!);
      result.value!.saveToJson();
      notifyListeners();
    }

    return result;
  }

  Result<LexiconCustomVariable> updateCustomVariable(LexiconCustomVariable oldVariable, String keyword, String name, String description, int color, List<String> words) {
    var result = _createVariable(keyword, name, description, color, words, oldVariable);

    if(result.isSuccess) {
      int index = _customVariables.indexOf(oldVariable);
      _customVariables[index] = result.value!;

      BotFiles().deleteFile("lexicon/variables/${oldVariable.keyword}.json");
      result.value!.saveToJson();

      notifyListeners();
    }

    return result;
  }

  void deleteCustomVariable(LexiconCustomVariable variable) {
    if(!_customVariables.remove(variable)) return;

    BotFiles().deleteFile("lexicon/variables/${variable.keyword}.json");

    notifyListeners();
  }

  Result<LexiconCustomVariable> _createVariable(String keyword, String name, String description, int color, List<String> words, [LexiconCustomVariable? oldVariable]) {
    if(name.isEmpty || name.replaceAll(" ", "").isEmpty) return Result.failure("Name cannot be empty.");
    if(RegExp(r'[^\w]').hasMatch(keyword)) return Result.failure("Name and Keyword cannot contain any character besides underscores.");
    if(description.isNotEmpty && description.replaceAll(" ", "").isEmpty) return Result.failure("Description contains only whitespaces. Make it empty or write something!");

    for(var w in MainMenuRouter().getActiveMainRoute().getWindows()) {
      if(w is! LexiconVariableWindow && (keyword == "add_variable" || keyword == w.route)) return Result.failure("'$keyword' is a restricted keyword used by the application, using it will cause errors!");
    }

    for(var d in ConversationDelimiters.values) {
      if(d.delimiter == keyword) return Result.failure("'$keyword' is a restricted keyword used by the application, using it will cause errors!");
    }

    for(var event in _events) {
      for(var v in event.variables) {
        if(v.keyword == keyword) return Result.failure("The keyword '\$$keyword\$' is used by a predefined variable. Choose another one!");
      }
    }

    for(var v in _customVariables) {
      if(oldVariable == v) continue;
      if(v.keyword == keyword) return Result.failure("There is another variable with the same keyword. Change it!");
    }

    for(var w in words) {
      if(w.isEmpty || w.replaceAll(" ", "").isEmpty) return Result.failure("One or more words are empty.");
    }

    return Result.success(LexiconCustomVariable(keyword, name, description, color, words));
  }
  //
}