import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/util/result.dart';

class BotProfile {
  final String _token;
  late String _id;
  late String _name;
  late String _avatarUrl;

  BotProfile._contructor(this._token);

  static BotProfile create(String? token, String? id, String? name, String? avatarUrl) {
    if(token == null || id == null || name == null || avatarUrl == null) throw Exception("One of the parameters were null.");

    BotProfile bot = BotProfile._contructor(token);
    bot._id = id;
    bot._avatarUrl = avatarUrl;
    bot._name = name;

    return bot;
  }
  
  static Future<Result<BotProfile>> createWithToken(String token) async {
    var profile = BotProfile._contructor(token);
    NyxxGateway client;

    try {
      client = await Nyxx.connectGateway(
        token,
        GatewayIntents.all,
        options: GatewayClientOptions(plugins: [logging, cliIntegration,]),
      );
    } catch (e) {
      return Result<BotProfile>.failure("Token is not valid. 😂😂😂");
    }
    

    var user = await client.user.manager.fetchCurrentUser();
    profile._id = user.id.toString();
    profile._name = user.username;
    profile._avatarUrl = user.avatar.url.toString();

    await client.close();

    return Result<BotProfile>.success(profile);
  }

  String getToken() {
    return _token;
  }

  String getId() {
    return _id;
  }

  String getUsername() {
    return _name;
  }

  String getAvatarUrl() {
    return _avatarUrl;
  }

  
}