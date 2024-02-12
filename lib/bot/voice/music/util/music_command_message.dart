import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/voice/music/music_queue.dart';
import 'package:umbrage_bot/bot/voice/music/music_track.dart';

class MusicCommandMessage {
  late final Snowflake guildId;

  MusicCommandMessage(MusicQueue queue) {
    guildId = queue.guildId;

    queue.onTrackQueued.listen((track) {
      playCommandMessage(track);
    });

    queue.onTrackSkipped.listen((pair) {
      skipCommandMessage(pair.first, pair.second);
    });

    queue.onLoopChanged.listen((pair) {
      loopCommandMessage(pair.first, pair.second);
    });
  }

  void playCommandMessage(MusicTrack musicTrack) async {
    var track = musicTrack.track;
    var channel = await _getChannel(guildId);
    channel.sendMessage(MessageBuilder(embeds: [
      EmbedBuilder(
        title: track.info.title,
        url: track.info.uri,
        color: const DiscordColor(0xffffff),
        thumbnail: track.info.artworkUrl == null ? null : EmbedThumbnailBuilder(url: track.info.artworkUrl!),
        author: EmbedAuthorBuilder(
          name: _getMemberName(musicTrack.member),
          iconUrl: musicTrack.member.user!.avatar.url
        ),
        fields: [
          EmbedFieldBuilder(
            name: "Author", 
            value: track.info.author, 
            isInline: true
          ),
          EmbedFieldBuilder(
            name: "Duration", 
            value: track.info.length.toString().split('.')[0], 
            isInline: true
          ),
        ]
      )
    ]));
  }

  void skipCommandMessage(MusicTrack skippedTrack, Member member) async {
    var track = skippedTrack.track;
    var channel = await _getChannel(guildId);
    channel.sendMessage(MessageBuilder(embeds: [
      EmbedBuilder(
        title: track.info.title,
        color: const DiscordColor(0xff0000),
        thumbnail: track.info.artworkUrl == null ? null : EmbedThumbnailBuilder(url: track.info.artworkUrl!),
        author: EmbedAuthorBuilder(
          name: "${_getMemberName(member)} skipped:",
          iconUrl: skippedTrack.member.user!.avatar.url
        ),
      )
    ]));
  }

  void loopCommandMessage(Member member, bool b) async {
    var channel = await _getChannel(guildId);
    channel.sendMessage(MessageBuilder(embeds: [
      EmbedBuilder(
        title: b ? "LOOP ON" : "LOOP OFF",
        color: const DiscordColor(0x0000ff),
        author: EmbedAuthorBuilder(
          name: _getMemberName(member),
          iconUrl: member.user!.avatar.url
        ),
      )
    ]));
  }

  String _getMemberName(Member member) {
    if(member.nick != null) return member.nick!;
    if(member.user!.globalName != null) return member.user!.globalName!;
    return member.user!.username;
  }

  Future<TextChannel> _getChannel(Snowflake guildId) async 
    => await Bot().client.channels.get(Snowflake(Bot().config[guildId].musicChannelId)) as TextChannel;
}