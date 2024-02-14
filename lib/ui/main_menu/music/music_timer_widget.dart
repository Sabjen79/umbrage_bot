import 'dart:async';

import 'package:flutter/material.dart';
import 'package:umbrage_bot/ui/components/simple_discord_button.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';

class MusicTimerWidget extends StatefulWidget {
  final String name;
  final bool isEnabled;
  final String Function() getDurationString;
  final VoidCallback onRunEarly;

  const MusicTimerWidget({
    required this.name,
    required this.isEnabled,
    required this.getDurationString,
    required this.onRunEarly,
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


  @override
  Widget build(BuildContext context) {
    if(!widget.isEnabled) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: DiscordTheme.black,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Center(child: Text("${widget.name} is disabled"))
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: DiscordTheme.black,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        children: [
          Text(
            "${widget.name} Timer",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${widget.getDurationString()} left",
                  style: const TextStyle(
                    color: DiscordTheme.white2
                  ),
                ),
                const SizedBox(width: 50),
                SimpleDiscordButton(
                  width: 80,
                  height: 20,
                  text: "Run Early",
                  onTap: () async {
                    widget.onRunEarly();
                    setState(() {});
                  },
                ),
              ],
            ),
          )
          
        ],
      ),
    );
  }
}