import 'package:nyxx/nyxx.dart';
import 'package:nyxx_lavalink/nyxx_lavalink.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/conversation/chat_alert.dart';
import 'package:umbrage_bot/bot/voice/music/commands/music_command.dart';
import 'package:umbrage_bot/bot/voice/music/music_queue.dart';
import 'package:umbrage_bot/bot/voice/music/music_track.dart';

class PlayCommand extends MusicCommand {
  @override
  bool validateEvent(MessageCreateEvent event) {
    final String content = event.message.content;

    if(!content.startsWith("-p ") && !content.startsWith("-play ") && content.split(' ').length != 2) return false;

    return true;
  }

  @override
  Future<void> handleEvent(MessageCreateEvent event, final MusicQueue queue) async {

    TrackLoadResult track;

    try {
      track = await queue.lavalinkClient.loadTrack(event.message.content.split(' ')[1]) as TrackLoadResult;
    } catch(e) {
      ChatAlert.sendAlert(event.message, Bot().config.errorLoadingTrackMessage);
      return;
    }

    var musicTrack = MusicTrack(
      track.data, 
      member: await event.member!.get(),
      isUnskippable: Bot().config.userUnskippable
    );

    if(queue.containsTrack(musicTrack)) {
      ChatAlert.sendAlert(event.message, Bot().config.duplicateTrackMessage);
      return;
    }

    event.message.delete();
    queue.queueSong(musicTrack);
  }
}