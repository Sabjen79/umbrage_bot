import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/components/event_handler.dart';
import 'package:umbrage_bot/bot/configuration/bot_configuration.dart';
import 'package:umbrage_bot/bot/lexicon/lexicon.dart';
import 'package:umbrage_bot/bot/profile/bot_profile.dart';
import 'package:umbrage_bot/bot/profile/bot_profile_list.dart';
import 'package:umbrage_bot/bot/util/bot_files/bot_files.dart';

class Bot {
  late final NyxxGateway client; // Discord Client
  late final User user;
  late final BotConfiguration config;
  late final Lexicon lexicon;
  late final EventHandler eventHandler;
  //final ProfilePictureChanger _pfpChanger = ProfilePictureChanger();

  // Singleton
  static final Bot _instance = Bot._init();

  factory Bot() {
    return _instance;
  }
    
  Bot._init();
  
  //==============================================================================

  static Future<void> create(BotProfile profile) async {
    _instance.client = await Nyxx.connectGateway(
      profile.getToken(),
      GatewayIntents.all,
      options: GatewayClientOptions(
        loggerName: 'Umbrage',
        plugins: [
          logging, 
          cliIntegration
        ]
      ),
    //The bot is set on 'Do Not Disturb' and cannot be changed because he is too exalted to be perturbed by commoners.
    )..updatePresence(PresenceBuilder(status: CurrentUserStatus.dnd, isAfk: false));
    
    _instance.user = await _instance.client.user.manager.fetchCurrentUser();

    // Updates the username and avatar
    BotProfileList().updateProfile(profile.getToken());

    // Initializes BotFiles
    await BotFiles().initialize();
    
    _instance.config = BotConfiguration(await _instance.client.listGuilds());
    _instance.lexicon = Lexicon();
    _instance.eventHandler = EventHandler(_instance.client);
  }

  //==============================================================================

  Future<void> close() async {
    await client.close();
  }
}