import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/bot/util/bot_timer.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';

class ExtensionCooldownWidget extends StatefulWidget {
  final BotTimer timer;
  final bool canTimerRunEarly;

  const ExtensionCooldownWidget({
    required this.timer,
    this.canTimerRunEarly = true,
    super.key
  });

  @override
  State<ExtensionCooldownWidget> createState() => _ExtensionCooldownWidgetState();
}

class _ExtensionCooldownWidgetState extends State<ExtensionCooldownWidget> {
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
      milliseconds: widget.timer.runTime.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch
    ).toString().split('.').first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.canTimerRunEarly ? 190 : 170,
      margin: const EdgeInsets.only(left: 5),
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: DiscordTheme.darkGray,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () {
                widget.timer.restart();
                setState(() {});
              },
              child: Tooltip(
                verticalOffset: 15,
                message: "Restart",
                showDuration: Duration.zero,
                textStyle: const TextStyle(
                  color: DiscordTheme.white2
                ),
                decoration: BoxDecoration(
                  color: DiscordTheme.backgroundColorDarker.withAlpha(240),
                  borderRadius: BorderRadius.circular(5)
                ),
                child: const Icon(
                  Symbols.restart_alt,
                  fill: 1,
                  opticalSize: 20,
                ),
              )
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              "Cooldown: ${_getTime()}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: DiscordTheme.white
              ),
            ),
          ),
          widget.canTimerRunEarly ? Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                widget.timer.runEarly();
                setState(() {});
              },
              child: Tooltip(
                verticalOffset: 15,
                message: "Run Early",
                showDuration: Duration.zero,
                textStyle: const TextStyle(
                  color: DiscordTheme.white2
                ),
                decoration: BoxDecoration(
                  color: DiscordTheme.backgroundColorDarker.withAlpha(240),
                  borderRadius: BorderRadius.circular(5)
                ),
                child: const Icon(
                  Symbols.play_arrow,
                  fill: 1,
                  opticalSize: 20,
                ),
              ),
            ),
          ) : const SizedBox.shrink()
        ],
      )
    );
    
  }
}