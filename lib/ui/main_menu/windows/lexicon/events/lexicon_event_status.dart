import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/bot/lexicon/events/lexicon_event.dart';

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
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _color = !widget.event.enabled ? const Color(0xFFCC0A0A) : const Color(0xFF13AA08);

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
            widget.event.enabled ? "Ready" : "Disabled",
            style: TextStyle(
              color: _color,
              fontWeight: FontWeight.w500,
              fontSize: 14
            ),
          ),
        ),
      ],
    );
  }
}