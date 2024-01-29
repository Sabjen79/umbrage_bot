import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/profile/bot_profile.dart';
import 'package:umbrage_bot/bot/util/result.dart';

class BotProfileList {
  final _storage = const FlutterSecureStorage();
  List<BotProfile> _profiles = [];

  // Singleton
  static final BotProfileList _instance = BotProfileList._init();

  factory BotProfileList() {
    return _instance;
  }

  BotProfileList._init();
  //

  Future<void> saveProfiles() async {
    if(_profiles == []) return;

    String ids = "";
    for(var bot in _profiles) {
      String id = bot.getId();

      if(ids != "") ids += ",";
      ids += id;
      
      await _storage.write(key: "${id}_token", value: bot.getToken());
      await _storage.write(key: "${id}_username", value: bot.getUsername());
      await _storage.write(key: "${id}_avatarurl", value: bot.getAvatarUrl());
    }

    await _storage.write(key: 'bot_profiles_ids', value: ids);
  }

  Future<List<BotProfile>> loadProfiles() async {
    _profiles = [];
    String? ids = await _storage.read(key: 'bot_profiles_ids');

    if(ids == null || ids == '') {
      await _storage.write(key: 'bot_profiles_ids', value: null);
      return [];
    }

    for(var id in ids.split(',')) {
      _profiles.add(
        BotProfile.create(
          await _storage.read(key: "${id}_token"),
          id,
          await _storage.read(key: "${id}_username"),
          await _storage.read(key: "${id}_avatarurl")
        )
      );
    }

    return _profiles;
  }

  Future<Result<BotProfile>> createProfile(String token) async {
    var result = await BotProfile.createWithToken(token);

    if(!result.isSuccess) return result;

    var newProfile = result.value!;

    for(var profile in _profiles) {
      if(newProfile.getId() == profile.getId()) return Result<BotProfile>.failure("This bot is already added 😵😵😵");
    }

    _profiles.add(newProfile);
    await saveProfiles();
    return Result<BotProfile>.success(newProfile);
  }

  Future<void> deleteProfile(String id) async {
    for(var profile in _profiles) {
      if(profile.getId() == id) {
        await _storage.delete(key: "${id}_token");
        await _storage.delete(key: "${id}_username");
        await _storage.delete(key: "${id}_avatarurl");

        _profiles.remove(profile);
        await saveProfiles();
        return;
      }
    }    
  }

  // Only called after Bot is connected
  Future<void> updateProfile(String token) async {
    var newProfile = BotProfile.create(token, Bot().user.id.toString(), Bot().user.username, Bot().user.avatar.url.toString());
    for(int i = 0; i < _profiles.length; i++) {
      var oldProfile = _profiles[i];

      if(oldProfile.getToken() == newProfile.getToken()) {
        _profiles[i] = newProfile;
      }
    }

    await saveProfiles();
    return;
  }
}