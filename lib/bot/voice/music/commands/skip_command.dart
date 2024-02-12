import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/conversation/chat_alert.dart';
import 'package:umbrage_bot/bot/voice/music/commands/music_command.dart';
import 'package:umbrage_bot/bot/voice/music/music_queue.dart';

class SkipCommand extends MusicCommand {
  @override
  bool validateEvent(MessageCreateEvent event) {
    final String content = event.message.content.trim();

    if(content != '-s' && content != '-skip') return false;

    return true;
  }

  @override
  Future<void> handleEvent(MessageCreateEvent event, final MusicQueue queue) async {
    if(queue.currentTrack == null) {
      ChatAlert.sendAlert(event.message, "There is nothing to skip!");
      return;
    }

    event.message.delete();
    queue.skip(await event.member!.get());
  }
}