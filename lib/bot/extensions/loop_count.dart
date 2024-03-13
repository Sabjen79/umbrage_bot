import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/util/bot_files.dart';
import 'package:umbrage_bot/bot/util/json_serializable.dart';
import 'package:umbrage_bot/bot/util/pseudo_random_index.dart';
import 'package:umbrage_bot/bot/voice/music/music_track.dart';

class LoopCount with JsonSerializable {
  bool enable = false;
  int triggerMultiple = 0;
  int triggerStart = 0;
  bool messageOnEnd = false;

  List<String> messages = [];
  List<String> endMessages = [];
  late PseudoRandomIndex _messagesIndexes, _endMessagesIndexes;
  final Map<Snowflake, _GuildTrackRepeat> _currentRepeats = {};

  LoopCount(List<Guild> guilds) {
    reset();

    for(final g in guilds) {
      _currentRepeats[g.id] = _GuildTrackRepeat();

      final queue = Bot().voiceManager[g.id].music.queue;

      queue.onCurrentTrackChanged.listen((track) {
        handleEvent(g.id, track);
      });
    }
  }

  void handleEvent(Snowflake guildId, MusicTrack? track) async {
    if(!enable || (track != null && track.hidden)) return;
    final currentRepeat = _currentRepeats[guildId]!;

    if(currentRepeat.track != track) {
      if(messageOnEnd && currentRepeat.count >= triggerStart) {
        final channel = await Bot().client.channels.get(Snowflake(Bot().config[guildId].musicChannelId)) as TextChannel;
        await currentRepeat.message?.delete();

        currentRepeat.count++;

        var content = endMessages[_endMessagesIndexes.getNextIndex()];
        content = content
          .replaceAll(r"$title$", currentRepeat.track!.track.info.title)
          .replaceAll(r"$time$", (currentRepeat.track!.track.info.length * currentRepeat.count).toString().substring(0, 7))
          .replaceAll(r"$count$", currentRepeat.count.toString());

        currentRepeat.message = await channel.sendMessage(MessageBuilder(
          content: content
        ));
      }

      currentRepeat.track = track;
      currentRepeat.count = 0;
      currentRepeat.message = null;
    } else if(track != null) {
      currentRepeat.count++;

      final count = currentRepeat.count;
      if(count < triggerStart || count % triggerMultiple != 0) return;

      final channel = await Bot().client.channels.get(Snowflake(Bot().config[guildId].musicChannelId)) as TextChannel;
      await currentRepeat.message?.delete();

      var content = messages[_messagesIndexes.getNextIndex()];
      content = content
        .replaceAll(r"$title$", currentRepeat.track!.track.info.title)
        .replaceAll(r"$time$", (currentRepeat.track!.track.info.length * count).toString().substring(0, 7))
        .replaceAll(r"$count$", count.toString());

      currentRepeat.message = await channel.sendMessage(MessageBuilder(
        content: content
      ));
    }
  }

  void reset() {
    var json = loadFromJson();

    enable = (json['enable'] ?? false) as bool;
    triggerMultiple = (json['triggerMultiple'] ?? 5) as int;
    triggerStart = (json['triggerStart'] ?? 5) as int;
    messageOnEnd = (json['messageOnEnd'] ?? false) as bool;
    messages = List<String>.from((json['messages'] ?? <String>[]));
    _messagesIndexes = PseudoRandomIndex(messages.length);
    endMessages = List<String>.from((json['endMessages'] ?? <String>[]));
    _endMessagesIndexes = PseudoRandomIndex(endMessages.length);
  }
  
  @override
  String get jsonFilepath => "${BotFiles().getMainDir().path}/loop_count.json";
  
  @override
  Map<String, dynamic> toJson() => {
    'enable': enable,
    'triggerMultiple': triggerMultiple,
    'triggerStart': triggerStart,
    'messageOnEnd': messageOnEnd,
    'messages': messages,
    'endMessages': endMessages
  };
}

class _GuildTrackRepeat {
  MusicTrack? track;
  int count;
  Message? message;

  _GuildTrackRepeat() : count = 0;
}