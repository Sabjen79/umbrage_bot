import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/bot/lexicon/events/lexicon_event.dart';
import 'package:umbrage_bot/ui/components/simple_discord_button.dart';

class LexiconEventStatus extends StatefulWidget {
  final LexiconEvent event;

  const LexiconEventStatus({required this.event, super.key});

  @override
  State<LexiconEventStatus> createState() => _LexiconEventStatusState();
}

class _LexiconEventStatusState extends State<LexiconEventStatus> {
  late Color _color;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _remainingCooldown() {
    double secondsLeft = widget.event.cooldownLeft / 1000 + 1; // Added one second to compensate for the remaining milliseconds

    int h = secondsLeft ~/ 3600;
    secondsLeft = (secondsLeft / 3600) % 1;
    int m = (secondsLeft * 60).truncate();
    secondsLeft = (secondsLeft * 60) % 1;
    int s = (secondsLeft * 60).truncate(); 

    return 
      (h == 0 ? "" : h == 1 ? "$h hour " : "$h hours ") + 
      (m == 0 ? "" : m == 1 ? "$m minute " : "$m minutes ") + 
      (s == 0 ? "" : s == 1 ? "$s second" : "$s seconds");
  }

  @override
  Widget build(BuildContext context) {
    _color = !widget.event.enabled ? const Color(0xFFCC0A0A) : widget.event.onCooldown ? const Color(0xFFe3ce0d) : const Color(0xFF13AA08);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Symbols.circle,
          color: _color.withAlpha(200),
          size: 15,
          fill: 1,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 3, bottom: 1),
          child: Text(
            !widget.event.enabled ? "Disabled" : 
            widget.event.onCooldown ? "On Cooldown: ${_remainingCooldown()}": 
            "Ready",
            style: TextStyle(
              color: _color,
              fontWeight: FontWeight.w500,
              fontSize: 14
            ),
          ),
        ),

        !(widget.event.enabled && widget.event.onCooldown) ? Container(height: 25) : Expanded(
          child: Container(
            padding: const EdgeInsets.only(right: 20),
            alignment: Alignment.centerRight,
            child: SimpleDiscordButton(
              text: "End Cooldown",
              width: 80,
              height: 25,
              onTap: () async{
                setState(() {
                  widget.event.endCooldown();
                });
              },
            ),
          ),
        )
      ],
    );
  }
}