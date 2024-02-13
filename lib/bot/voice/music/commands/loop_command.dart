import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/conversation/chat_alert.dart';
import 'package:umbrage_bot/bot/voice/music/commands/music_command.dart';
import 'package:umbrage_bot/bot/voice/music/music_queue.dart';

class LoopCommand extends MusicCommand {
  @override
  Future<bool> validateEvent(MessageCreateEvent event) async {
    final String content = event.message.content.trim();

    if(content != '-l' && content != '-loop') return false;

    return true;
  }

  @override
  Future<void> handleEvent(MessageCreateEvent event, final MusicQueue queue) async {
    if(queue.currentTrack == null) {
      ChatAlert.sendAlert(event.message, "There is nothing to loop!");
      return;
    }

    event.message.delete();
    queue.toggleLoop(await event.member!.get());
  }
}