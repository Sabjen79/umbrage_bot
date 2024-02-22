import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';

class ProfilePictureCooldown extends StatefulWidget {
  const ProfilePictureCooldown({super.key});

  @override
  State<ProfilePictureCooldown> createState() => _ProfilePictureCooldownState();
}

class _ProfilePictureCooldownState extends State<ProfilePictureCooldown> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _getTime() {
    return Duration(
      milliseconds: Bot().profilePictureManager.timer.runTime.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch
    ).toString().split('.').first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(left: 5),
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: DiscordTheme.backgroundColorDarker
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Bot().profilePictureManager.timer.restart();
              setState(() {});
            },
            child: const Icon(
              Symbols.refresh,
              size: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 3),
            child: Text(
              "Cooldown: ${_getTime()}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: DiscordTheme.white
              ),
            ),
          ),
          
        ],
      )
    );
    
  }
}