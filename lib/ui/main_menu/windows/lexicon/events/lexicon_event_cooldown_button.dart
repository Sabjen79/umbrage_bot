import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/lexicon/events/lexicon_event.dart';
import 'package:umbrage_bot/bot/lexicon/events/lexicon_private_event.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';
import 'package:umbrage_bot/ui/main_menu/secondary_side_bar/secondary_side_bar.dart';

class LexiconEventCooldownButton extends StatefulWidget {
  final LexiconEvent event;
  final Snowflake id;

  const LexiconEventCooldownButton({
    required this.event,
    required this.id,
    super.key
  });

  @override
  State<LexiconEventCooldownButton> createState() => _LexiconEventCooldownButtonState();
}

class _LexiconEventCooldownButtonState extends State<LexiconEventCooldownButton> with TickerProviderStateMixin {
  String? _name;
  String? _photoUrl;

  late AnimationController _hoverController;
  late Animation _hoverAnimation;
  late Timer _timer;

  bool _hover = false;

  @override
  void initState() {
    super.initState();

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _hoverAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _hoverController, curve: Curves.ease, reverseCurve: Curves.easeIn));
    _hoverController.addListener(() {
      setState(() {});
    });

    init();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant LexiconEventCooldownButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    init();
  }

  void init() {
    if(widget.event is LexiconPrivateEvent) {
      Bot().client.users.get(widget.id).then((value) {
        _name = value.username;
        _photoUrl = value.avatar.url.toString();
      });
    } else {
      final guild = Bot().guildList.firstWhere((element) => element.id == widget.id);
      _name = guild.name;
      _photoUrl = guild.icon?.url.toString();
    }
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (b) {
        setState(() {
          _hover = b;

          b ? _hoverController.forward() : _hoverController.reverse();
        });
      },
      onTap: () {
        widget.event.endCooldown(widget.id);
      },
      child: Container(
        decoration: BoxDecoration(
          color: _hover? const Color(0x0AFFFFFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(4)
        ),
        padding: const EdgeInsets.symmetric(horizontal: 3),
        margin: const EdgeInsets.symmetric(vertical: 2),
        width: SecondarySideBar.size,
        height: 35,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: <Widget>[
            Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(5).add(const EdgeInsets.only(right: 3)),
                  width: 22,
                  height: 22,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(22)
                  ),
                  child: _photoUrl == null ? const SizedBox.shrink() : Image.network(
                    _photoUrl!,
                    fit: BoxFit.cover,
                  ),
                ),
                
                Container(
                  decoration: const BoxDecoration(),
                  clipBehavior: Clip.hardEdge,
                  padding: const EdgeInsets.only(bottom: 2),
                  width: 135,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _name ?? "...", 
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: DiscordTheme.white2,
                          fontSize: 12,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      
                      Text(
                        "Cooldown Left: ${Duration(milliseconds: widget.event.cooldowns[widget.id]!.runTime.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch).toString().substring(0, 7)}", 
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: DiscordTheme.lightGray,
                          fontSize: 10
                        ),
                      )
                    ]
                  ),
                )
              ],
            ),
            Positioned(
              right: SecondarySideBar.size - 10,
              child: Container(
                transform: Matrix4( // ScaleX & TranslateX
                  _hover ? 0.95 + 0.05 * _hoverAnimation.value : 0, 0, 0, 0,
                  0, _hover ? 0.95 + 0.05 * _hoverAnimation.value : 0, 0, 0,
                  0, 0, 1, 0,
                  (1.0 - _hoverAnimation.value) * 15, 0, 0, 1,
                ),
                decoration: const BoxDecoration(
                  color: DiscordTheme.black,
                  borderRadius: BorderRadius.all(Radius.circular(3))
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 200),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    child: Text(
                      "Click to cancel cooldown",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12
                      ),
                    ),
                  ),
                )
              ),
            ),
          ],
        )
      )
    );
  }
}