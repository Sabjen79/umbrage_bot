import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/voice/music/music_queue.dart';

abstract class MusicCommand {
  Future<bool> validateEvent(MessageCreateEvent event);
  Future<void> handleEvent(MessageCreateEvent event, final MusicQueue queue);
}