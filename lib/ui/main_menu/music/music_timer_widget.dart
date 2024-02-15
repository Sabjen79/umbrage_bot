import 'dart:async';

import 'package:flutter/material.dart';
import 'package:umbrage_bot/bot/util/bot_timer.dart';
import 'package:umbrage_bot/ui/components/simple_discord_button.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';

class MusicTimerWidget extends StatefulWidget {
  final String name;
  final BotTimer? timer;

  const MusicTimerWidget({
    required this.name,
    required this.timer,
    super.key
  });

  @override
  State<MusicTimerWidget> createState() => _MusicTimerWidgetState();
}

class _MusicTimerWidgetState extends State<MusicTimerWidget> {
  late Timer timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String _durationString() {
    final timer = widget.timer;
    if(timer == null) return "";
    final duration = timer.runTime.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch;
    return Duration(milliseconds: duration).toString().split('.')[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: DiscordTheme.black,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${widget.name} Timer",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${_durationString()} left",
                style: const TextStyle(
                  color: DiscordTheme.white2
                ),
              ),
              const SizedBox(width: 40),
              SimpleDiscordButton(
                width: 80,
                height: 20,
                text: "Run Early",
                onTap: () async {
                  widget.timer?.runEarly();
                  setState(() {});
                },
              ),
            ],
          )
          
        ],
      ),
    );
  }
}