import 'dart:math';

import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/configuration/bot_guild_configuration.dart';
import 'package:umbrage_bot/bot/util/bot_files.dart';
import 'package:umbrage_bot/bot/util/json_serializable.dart';
import 'package:umbrage_bot/bot/util/random_cooldown.dart';

class BotConfiguration with JsonSerializable {
  final Map<String, BotGuildConfiguration> _guilds = {};
  late int typingSpeed;
  late int reactionSpeedMin;
  late int reactionSpeedMax;
  int get randomReactionSpeed => Random().randomCooldown(reactionSpeedMin, reactionSpeedMax);

  late String ytNotFoundMessage;

  late bool restrictMusicChannel;
  late String restrictMusicChannelMessage;
  late bool autoConnectVoice;
  late bool autoConnectVoicePersist;
  late String invalidMusicCommandChannelMessage;
  late String errorLoadingTrackMessage;
  late String duplicateTrackMessage;
  late String emptyQueueMessage;
  late String noVoiceChannelMessage;
  late String noLoopMessage;
  late String noClearMessage;
  late String clearMessage;
  late String clearPartialMessage;

  late bool unskippableSongs;
  late double userUnskippableChance;
  late double botUnskippableChance;
  late String unskippableMessage;
  late int unskippableMinDuration;
  late int unskippableMaxDuration;
  late bool unskippableClearImmunity;
  int get randomUnskippableDuration => Random().randomCooldown(unskippableMinDuration, unskippableMaxDuration);
  bool get userUnskippable => unskippableSongs && Random().nextDouble() < userUnskippableChance;
  bool get botUnskippable => unskippableSongs && Random().nextDouble() < botUnskippableChance;

  late bool randomMusicEnable;
  late int randomMusicMinCooldown;
  late int randomMusicMaxCooldown;
  late double randomMusicSkipChance;
  int get randomMusicCooldown => Random().randomCooldown(randomMusicMinCooldown, randomMusicMaxCooldown);

  late bool volumeBoostEnable;
  late int volumeBoostMinCooldown;
  late int volumeBoostMaxCooldown;
  late int volumeBoostAmplitude;
  int get volumeBoostCooldown => Random().randomCooldown(volumeBoostMinCooldown, volumeBoostMaxCooldown);

  late bool muteKickEnable;
  late bool muteKickOnlyMute;
  late bool muteKickIgnoreAfk;
  late int muteKickDuration;

  late bool profilePictureEnable;
  late int profilePictureMinCooldown;
  late int profilePictureMaxCooldown;
  int get profilePictureCooldown => Random().randomCooldown(profilePictureMinCooldown, profilePictureMaxCooldown);

  late bool randomSoundsEnable;
  late bool randomSoundsPlayOnJoin;
  late int randomSoundsMinCooldown;
  late int randomSoundsMaxCooldown;
  late double randomSoundsLoopChance;
  bool get randomSoundsLoop => randomSoundsEnable && Random().nextDouble() < randomSoundsLoopChance;

  BotConfiguration(List<PartialGuild> guilds) {
    for(var g in guilds) {
      _guilds[g.id.toString()] = BotGuildConfiguration(g.id.toString());
    }

    Bot().client.onGuildCreate.listen((event) {
      _guilds[event.guild.id.toString()] = BotGuildConfiguration(event.guild.id.toString());
    });

    reset();
  }

  void reset() {
    var json = loadFromJson();
    ytNotFoundMessage = (json['ytNotFoundMessage'] ?? "I couldn't find any video") as String;

    typingSpeed = (json['typingSpeed'] ?? 30) as int;
    reactionSpeedMin = (json['reactionSpeedMin'] ?? 1000) as int;
    reactionSpeedMax = (json['reactionSpeedMax'] ?? 1500) as int;

    restrictMusicChannel = (json['restrictMusicChannel'] ?? true) as bool;
    restrictMusicChannelMessage = (json['restrictMusicChannelMessage'] ?? "You can only queue music here!") as String;
    autoConnectVoice = (json['autoConnectVoice'] ?? true) as bool;
    autoConnectVoicePersist = (json['autoConnectVoicePersist'] ?? false) as bool;
    invalidMusicCommandChannelMessage = (json['invalidMusicCommandChannelMessage'] ?? "Music Commands can only be used in \$channel\$") as String;
    errorLoadingTrackMessage = (json['errorLoadingTrackMessage'] ?? "Error loading track!") as String;
    duplicateTrackMessage = (json['duplicateTrackMessage'] ?? "This track is already in queue") as String;
    emptyQueueMessage = (json['emptyQueueMessage'] ?? "There is nothing to skip!") as String;
    noVoiceChannelMessage = (json['noVoiceChannelMessage'] ?? "You must be connected to a voice channel!") as String;
    noLoopMessage = (json['noLoopMessage'] ?? "There is nothing to loop!") as String;
    noClearMessage = (json['noClearMessage'] ?? "There is nothing to clear!") as String;
    clearMessage = (json['clearMessage'] ?? "\$ cleared the queue") as String;
    clearPartialMessage = (json['clearPartialMessage'] ?? "\$ cleared the queue. But some songs remain...") as String;

    unskippableSongs = (json['unskippableSongs'] ?? false) as bool;
    userUnskippableChance = (json['userUnskippableChance'] ?? 0.1) as double;
    botUnskippableChance = (json['botUnskippableChance'] ?? 0.3) as double;
    unskippableMessage = (json['unskippableMessage'] ?? "I won't skip that!") as String;
    unskippableMinDuration = (json['unskippableMinDuration'] ?? 300000) as int;
    unskippableMaxDuration = (json['unskippableMaxDuration'] ?? 600000) as int;
    unskippableClearImmunity = (json['unskippableClearImmunity'] ?? true) as bool;
    
    randomMusicEnable = (json['randomMusicEnable'] ?? false) as bool;
    randomMusicMinCooldown = (json['randomMusicMinCooldown'] ?? 600000) as int;
    randomMusicMaxCooldown = (json['randomMusicMaxCooldown'] ?? 1200000) as int;
    randomMusicSkipChance = (json['randomMusicSkipChance'] ?? 0.3) as double;

    volumeBoostEnable = (json['volumeBoostEnable'] ?? false) as bool;
    volumeBoostMinCooldown = (json['volumeBoostMinCooldown'] ?? 3600000) as int;
    volumeBoostMaxCooldown = (json['volumeBoostMaxCooldown'] ?? 7200000) as int;
    volumeBoostAmplitude = (json['volumeBoostAmplitude'] ?? 200) as int;

    muteKickEnable = (json['muteKickEnable'] ?? false) as bool;
    muteKickOnlyMute = (json['muteKickOnlyMute'] ?? true) as bool;
    muteKickIgnoreAfk = (json['muteKickIgnoreAfk'] ?? true) as bool;
    muteKickDuration = (json['muteKickDuration'] ?? 300000) as int;

    profilePictureEnable = (json['profilePictureEnable'] ?? false) as bool;
    profilePictureMinCooldown = (json['profilePictureMinCooldown'] ?? 1800000) as int;
    profilePictureMaxCooldown = (json['profilePictureMaxCooldown'] ?? 3600000) as int;

    randomSoundsEnable = (json['randomSoundsEnable'] ?? false) as bool;
    randomSoundsPlayOnJoin = (json['randomSoundsPlayOnJoin'] ?? false) as bool;
    randomSoundsMinCooldown = (json['randomSoundsMinCooldown'] ?? 600000) as int;
    randomSoundsMaxCooldown = (json['randomSoundsMaxCooldown'] ?? 1200000) as int;
    randomSoundsLoopChance = (json['randomSoundsLoopChance'] ?? 0.0) as double;
  }

  @override
  Map<String, dynamic> toJson() => {
    'ytNotFoundMessage': ytNotFoundMessage,
    'typingSpeed': typingSpeed,
    'reactionSpeedMin': reactionSpeedMin,
    'reactionSpeedMax': reactionSpeedMax,
    'restrictMusicChannel': restrictMusicChannel,
    'restrictMusicChannelMessage': restrictMusicChannelMessage,
    'autoConnectVoice': autoConnectVoice,
    'autoConnectVoicePersist': autoConnectVoicePersist,
    'invalidMusicCommandChannelMessage': invalidMusicCommandChannelMessage,
    'errorLoadingTrackMessage': errorLoadingTrackMessage,
    'duplicateTrackMessage': duplicateTrackMessage,
    'emptyQueueMessage': emptyQueueMessage,
    'noVoiceChannelMessage': noVoiceChannelMessage,
    'noLoopMessage': noLoopMessage,
    'noClearMessage': noClearMessage,
    'clearMessage': clearMessage,
    'clearPartialMessage': clearPartialMessage,
    'unskippableSongs': unskippableSongs,
    'userUnskippableChance': userUnskippableChance,
    'botUnskippableChance': botUnskippableChance,
    'unskippableMessage': unskippableMessage,
    'unskippableMinDuration': unskippableMinDuration,
    'unskippableMaxDuration': unskippableMaxDuration,
    'unskippableClearImmunity': unskippableClearImmunity,
    'randomMusicEnable': randomMusicEnable,
    'randomMusicMinCooldown': randomMusicMinCooldown,
    'randomMusicMaxCooldown': randomMusicMaxCooldown,
    'randomMusicSkipChance': randomMusicSkipChance,
    'volumeBoostEnable': volumeBoostEnable,
    'volumeBoostMinCooldown': volumeBoostMinCooldown,
    'volumeBoostMaxCooldown': volumeBoostMaxCooldown,
    'volumeBoostAmplitude': volumeBoostAmplitude,
    'muteKickEnable': muteKickEnable,
    'muteKickOnlyMute': muteKickOnlyMute,
    'muteKickIgnoreAfk': muteKickIgnoreAfk,
    'muteKickDuration': muteKickDuration,
    'profilePictureEnable': profilePictureEnable,
    'profilePictureMinCooldown': profilePictureMinCooldown,
    'profilePictureMaxCooldown': profilePictureMaxCooldown,
    'randomSoundsEnable': randomSoundsEnable,
    'randomSoundsPlayOnJoin': randomSoundsPlayOnJoin,
    'randomSoundsMinCooldown': randomSoundsMinCooldown,
    'randomSoundsMaxCooldown': randomSoundsMaxCooldown,
    'randomSoundsLoopChance': randomSoundsLoopChance
  };

  @override
  String get jsonFilepath => "${BotFiles().getMainDir().path}/config.json";

  BotGuildConfiguration operator[](Snowflake id) {
    if(_guilds[id.toString()] == null) throw Exception("There is no guild with that id");

    return _guilds[id.toString()]!;
  }
}