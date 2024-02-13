import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/conversation/chat_alert.dart';
import 'package:umbrage_bot/bot/voice/music/commands/loop_command.dart';
import 'package:umbrage_bot/bot/voice/music/commands/music_command.dart';
import 'package:umbrage_bot/bot/voice/music/commands/play_command.dart';
import 'package:umbrage_bot/bot/voice/music/commands/skip_command.dart';
import 'package:umbrage_bot/bot/voice/music/music_queue.dart';

class GuildMusicManager {
  final PartialGuild guild;
  final MusicQueue _musicQueue;
  final List<MusicCommand> _commands = [
    PlayCommand(),
    SkipCommand(),
    LoopCommand()
  ];

  GuildMusicManager(this.guild) : _musicQueue = MusicQueue(guild.id);

  void replayCurrentTrack() {
    _musicQueue.replayCurrentTrack();
  }

  bool handleEvent(MessageCreateEvent event) {
    final config = Bot().config[event.guildId!];
    final musicChannelId = config.musicChannelId;

    if(musicChannelId == 0) return false;

    for(var command in _commands) {
      if(command.validateEvent(event)) {

        if(event.message.channelId.value == musicChannelId) {
          command.handleEvent(event, _musicQueue);
        } else {
          ChatAlert.sendAlert(event.message, Bot().config.invalidMusicCommandChannelMessage.replaceAll('\$channel\$', "<#$musicChannelId>"));
        }
        
        return true;
      }
    }

    if(event.message.channelId.value == musicChannelId) {
      ChatAlert.sendAlert(event.message, Bot().config.restrictMusicChannelMessage);
      return true;
    }

    return false;
  }
}