import 'package:nyxx/nyxx.dart';
import 'package:nyxx_lavalink/nyxx_lavalink.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/conversation/chat_alert.dart';
import 'package:umbrage_bot/bot/voice/music/commands/music_command.dart';
import 'package:umbrage_bot/bot/voice/music/music_queue.dart';
import 'package:umbrage_bot/bot/voice/music/music_track.dart';
import 'package:umbrage_bot/bot/voice/music/util/youtube_search.dart';

class PlayCommand extends MusicCommand {
  String? url = "";

  @override
  Future<bool> validateEvent(MessageCreateEvent event) async {
    final String content = event.message.content;

    if(!content.startsWith("-p ") && !content.startsWith("-play ") && content.split(' ').length != 2) return false;

    url = event.message.content.substring(event.message.content.indexOf(" ") + 1).trim();

    if(!url!.startsWith('http') && Bot().config.ytApiKey.trim().isNotEmpty) {
      url = await YoutubeSearch.searchUrl(url!);
    }

    return true;
  }

  @override
  Future<void> handleEvent(MessageCreateEvent event, final MusicQueue queue) async {
    Track track;

    if(url == null || url == "") {
      ChatAlert.sendAlert(event.message, Bot().config.ytNotFoundMessage);
      return;
    }

    if(event.guild!.voiceStates[Bot().user.id]?.channel == null) {
      final userState = event.guild!.voiceStates[event.member!.id]!;
      Bot().voiceManager[event.guildId!].connectTo(userState.channelId);
    }

    try {
      var result = await queue.lavalinkClient.loadTrack(url!);
      if(result is TrackLoadResult) {
        track = result.data;
      } else if(result is PlaylistLoadResult) {
        var index = result.data.info.selectedTrack;
        if(index == -1) index = 0;
        track = result.data.tracks[index];
      } else {
        throw Exception("Not found!");
      }
    } catch(e) {
      ChatAlert.sendAlert(event.message, Bot().config.errorLoadingTrackMessage);
      return;
    }

    var musicTrack = MusicTrack(
      track, 
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