import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/lexicon/lexicon.dart';
import 'package:umbrage_bot/bot/profile/bot_profile.dart';
import 'package:umbrage_bot/bot/profile/bot_profile_list.dart';
import 'package:umbrage_bot/bot/util/bot_files/bot_files.dart';

class Bot {
  late NyxxGateway client; // Discord Client
  late User user;
  late final Lexicon lexicon;
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
        plugins: [
          logging, 
          cliIntegration
        ]
      ),
    );

    _instance.user = await _instance.client.user.manager.fetchCurrentUser();

    // Updates the username and avatar
    BotProfileList().updateProfile(profile.getToken());

    // Initializes BotFiles
    await BotFiles().initialize();
    _instance.lexicon = Lexicon();

    //The bot is set on 'Do Not Disturb' and cannot be changed because he is too exalted to be perturbed by commoners.
    _instance.client.updatePresence(PresenceBuilder(status: CurrentUserStatus.dnd, isAfk: false));
  }

  //==============================================================================

  Future<void> close() async {
    await client.close();
  }
}