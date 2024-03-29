import 'dart:async';
import 'dart:ui';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_lavalink/nyxx_lavalink.dart';
import 'package:umbrage_bot/bot/event_handler.dart';
import 'package:umbrage_bot/bot/configuration/bot_configuration.dart';
import 'package:umbrage_bot/bot/extensions/loop_count.dart';
import 'package:umbrage_bot/bot/extensions/mute_kick.dart';
import 'package:umbrage_bot/bot/extensions/profile_picture_manager.dart';
import 'package:umbrage_bot/bot/extensions/status_changer_manager.dart';
import 'package:umbrage_bot/bot/lexicon/lexicon.dart';
import 'package:umbrage_bot/profile/bot_profile.dart';
import 'package:umbrage_bot/profile/bot_profile_list.dart';
import 'package:umbrage_bot/bot/util/bot_files.dart';
import 'package:umbrage_bot/bot/voice/bot_voice_manager.dart';

class Bot {
  late final NyxxGateway client; // Discord Client
  late User user;
  late final BotConfiguration config;
  late final Lexicon lexicon;
  late final EventHandler eventHandler;
  late final BotVoiceManager voiceManager;
  late final MuteKick muteKick;
  late final ProfilePictureManager profilePictureManager;
  late final StatusChangerManager statusChangerManager;
  late final LoopCount loopCount;

  final List<Guild> _guildList = [];
  List<Guild> get guildList => _guildList;

  // Singleton
  static final Bot _instance = Bot._init();

  factory Bot() {
    return _instance;
  }
    
  Bot._init();
  
  //==============================================================================


  static Future<bool> create(BotProfile profile) async {
    _instance.client = await Nyxx.connectGateway(
      profile.getToken(),
      GatewayIntents.all,
      options: GatewayClientOptions(
        loggerName: 'Umbrage',
        plugins: [
          LavalinkPlugin(base: Uri.https("lavalink4-frankfurt.alfari.id:443"), password: "catfein"),
          logging, 
          cliIntegration
        ]
      ),
    );

    // Console Errors
    PlatformDispatcher.instance.onError = (object, stack) {
      logging.logger.severe("${object.toString()}:\n${stack.toString()}");
      return true;
    };
    
    //The bot is set on 'Do Not Disturb' and cannot be changed because he is too exalted to be perturbed by commoners.
    _instance.client.updatePresence(PresenceBuilder(status: CurrentUserStatus.dnd, isAfk: false));
    _instance.user = await _instance.client.user.manager.fetchCurrentUser();

    // Updates the username and avatar
    BotProfileList().updateProfile(profile.getToken());

    await BotFiles().initialize();

    await _instance.refreshGuildList();
    
    _instance
      ..config = BotConfiguration(_instance._guildList)
      ..lexicon = Lexicon()
      ..eventHandler = EventHandler(_instance.client)
      ..voiceManager = BotVoiceManager(_instance._guildList)
      ..muteKick = MuteKick()
      ..profilePictureManager = ProfilePictureManager()
      ..statusChangerManager = StatusChangerManager()
      ..loopCount = LoopCount(_instance._guildList);
    
    return true;
  }

  //==============================================================================

  Future<void> refreshGuildList() async {
    guildList.clear();

    for(final partialGuild in await client.listGuilds()) {
      guildList.add(await partialGuild.get());
    }
  }

  Future<Member> getBotMember(Snowflake guildId) async {
    Guild g = await client.guilds.get(guildId);
    return await g.members.get(user.id);
  }

  Future<void> close() async {
    await client.close();
  }
}