import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/conversation/chat_alert.dart';

class GuildMusicManager {
  final PartialGuild guild;

  GuildMusicManager(this.guild);

  bool handleEvent(MessageCreateEvent event) {
    final config = Bot().config[event.guildId!];
    final musicChannelId = config.musicChannelId;

    if(musicChannelId == 0) return false;

    if(event.message.channelId.value == musicChannelId) {
      ChatAlert.sendAlert(event.message, config.restrictMusicChannelMessage);
      return true;
    }

    return false;
  }
}