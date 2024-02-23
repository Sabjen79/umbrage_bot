import 'dart:math';

import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/util/bot_files.dart';
import 'package:umbrage_bot/bot/util/bot_timer.dart';
import 'package:umbrage_bot/bot/util/json_serializable.dart';
import 'package:umbrage_bot/bot/util/pseudo_random_index.dart';
import 'package:umbrage_bot/bot/util/random_cooldown.dart';

class StatusChangerManager with JsonSerializable {
  late List<String> statusList;
  late PseudoRandomIndex pseudoRandomIndex;
  late bool enable;
  late int minCooldown;
  late int maxCooldown;
  late BotTimer timer;
  int get randomCooldown => Random().randomCooldown(minCooldown, maxCooldown);

  StatusChangerManager() {
    reset();

    timer = BotTimer.periodic(() => randomCooldown, () {
      if(!enable || statusList.isEmpty) {
        clearStatus();
        return;
      }

      ActivityBuilder? activity;
      final randomStatus = statusList[pseudoRandomIndex.getNextIndex()];

      switch(randomStatus[0]) {
        case '0':
          activity = ActivityBuilder(name: "Activity", type: ActivityType.custom, state: randomStatus.substring(1));
          break;
        case '1':
          activity = ActivityBuilder(name: randomStatus.substring(1), type: ActivityType.game);
          break;
        case '2':
          activity = ActivityBuilder(name: randomStatus.substring(1), type: ActivityType.watching);
          break;
        case '3':
          activity = ActivityBuilder(name: randomStatus.substring(1), type: ActivityType.listening);
        case '4':
          activity = ActivityBuilder(name: randomStatus.substring(1), type: ActivityType.streaming);
        case '5':
          activity = ActivityBuilder(name: randomStatus.substring(1), type: ActivityType.competing);
      }

      print(randomStatus[0]);

      if(activity == null) {
        clearStatus();
        return;
      }

      Bot().client.updatePresence(PresenceBuilder(
        status: CurrentUserStatus.dnd,
        isAfk: false,
        activities: [
          activity
        ]
      ));
    })..runEarly();
  }

  void clearStatus() {
    Bot().client.updatePresence(PresenceBuilder(
      status: CurrentUserStatus.dnd,
      isAfk: false,
    ));
  }

  void reset() {
    final json = loadFromJson();

    statusList = List<String>.from(json['statusList'] ?? []);
    enable = (json['enable'] ?? false) as bool;
    minCooldown = (json['minCooldown'] ?? 600000) as int;
    maxCooldown = (json['maxCooldown'] ?? 1200000) as int;

    pseudoRandomIndex = PseudoRandomIndex(statusList.length);
  }

  @override
  Map<String, dynamic> toJson() => {
    'enable': enable,
    'minCooldown': minCooldown,
    'maxCooldown': maxCooldown,
    'statusList': statusList,
  };
  
  @override
  String get jsonFilepath => "${BotFiles().getMainDir().path}/status_changer.json";
}