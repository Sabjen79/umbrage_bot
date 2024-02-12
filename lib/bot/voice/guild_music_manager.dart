import 'package:nyxx/nyxx.dart';
import 'package:nyxx_lavalink/nyxx_lavalink.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/conversation/chat_alert.dart';

class GuildMusicManager {
  final PartialGuild guild;
  LavalinkPlayer? player;

  GuildMusicManager(this.guild);

  bool handleEvent(MessageCreateEvent event) {
    final config = Bot().config[event.guildId!];
    final musicChannelId = config.musicChannelId;

    if(musicChannelId == 0) return false;

    if(event.message.channelId.value == musicChannelId) {
      ChatAlert.sendAlert(event.message, Bot().config.restrictMusicChannelMessage);
      return true;
    }

    return false;
  }
}