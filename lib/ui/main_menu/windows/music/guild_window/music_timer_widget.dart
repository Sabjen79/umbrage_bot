import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/bot/util/bot_timer.dart';
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

class _MusicTimerWidgetState extends State<MusicTimerWidget> with SingleTickerProviderStateMixin {
  late Timer timer;
  late AnimationController _hoverController;
  late Animation _hoverAnimation;
  bool _runEarlyHover = false;
  bool _restartHover = false;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });

    _hoverController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _hoverController.addListener(() {
      setState(() {});
    });

    _hoverAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _hoverController, curve: Curves.ease, reverseCurve: Curves.easeIn));
  }

  @override
  void dispose() {
    timer.cancel();
    _hoverController.dispose();
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
      clipBehavior: Clip.hardEdge,
      height: 30,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: DiscordTheme.black,
        borderRadius: BorderRadius.circular(15)
      ),
      child: IntrinsicWidth(
        child: MouseRegion(
          onEnter: (v) {
            _hoverController.forward();
          },
          onExit: (v) {
            _hoverController.reverse();
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: 1.0 - _hoverAnimation.value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
                  child: Text(
                    widget.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500
                    ),
                  ),
                )
              ),
              Positioned(
                top: 30.0 - _hoverAnimation.value * 25.5,
                child: Text(_durationString())
              ),
              Positioned(
                left: 5,
                child: Transform.translate(
                  offset: Offset(_hoverAnimation.value * 25 - 25.0, 0),
                  child: InkWell(
                    hoverColor: Colors.transparent,
                    onTap: () {
                      widget.timer?.restart();
                      setState(() {});
                    },
                    onHover: (b) {
                      setState(() {
                        _restartHover = b;
                      });
                    },
                    child: TooltipVisibility(
                      visible: _restartHover,
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
                        child: Icon(
                          Symbols.restart_alt,
                          fill: 1,
                          opticalSize: 20,
                          color: _restartHover ? DiscordTheme.white2 : DiscordTheme.white,
                        ),
                      ),
                    )
                  ),
                )
              ),
              Positioned(
                right: 5,
                child: Transform.translate(
                  offset: Offset(25.0 - _hoverAnimation.value * 25, 0),
                  child: InkWell(
                    hoverColor: Colors.transparent,
                    onTap: () {
                      widget.timer?.runEarly();
                      setState(() {});
                    },
                    onHover: (b) {
                      setState(() {
                        _runEarlyHover = b;
                      });
                    },
                    child: TooltipVisibility(
                      visible: _runEarlyHover,
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
                        child: Icon(
                          Symbols.play_arrow,
                          fill: 1,
                          opticalSize: 20,
                          color: _runEarlyHover ? DiscordTheme.white2 : DiscordTheme.white,
                        ),
                      ),
                    )
                  ),
                )
              )
            ],
          )
        )
      )
    );
  }
}