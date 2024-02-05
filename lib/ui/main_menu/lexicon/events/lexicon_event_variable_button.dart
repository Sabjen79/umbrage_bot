import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/bot/lexicon/variables/lexicon_variable.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';
import 'package:umbrage_bot/ui/main_menu/secondary_side_bar/secondary_side_bar.dart';

class LexiconEventVariableButton extends StatefulWidget {
  final LexiconVariable variable;

  const LexiconEventVariableButton({required this.variable, super.key});

  @override
  State<LexiconEventVariableButton> createState() => _LexiconEventVariableButtonState();
}

class _LexiconEventVariableButtonState extends State<LexiconEventVariableButton> with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation _hoverAnimation;

  late AnimationController _tapController;
  late Animation _tapAnimation;

  bool _hover = false;

  @override
  void initState() {
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _hoverAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _hoverController, curve: Curves.ease, reverseCurve: Curves.easeIn));
    _hoverController.addListener(() {
      setState(() {});
    });

    _tapController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _tapAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _tapController, curve: Curves.ease, reverseCurve: Curves.easeIn));
    _tapController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  double _getIconOpacity() {
    var value = _tapAnimation.value;

    if(value <= 0.1) return value/0.1;
    if(value >= 0.8) return (1-value)/0.2;
    return 1.0;
  }

  double _getIconRotation() {
    var value = _tapAnimation.value;

    if(value > 0.7) return 0.0;

    return 0.5*(1-_tapAnimation.value/0.7)*sin(_tapAnimation.value*25);
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
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: "\$${widget.variable.keyword}\$ "));
        
        _tapController..reset()..forward();
      },
      child: Container(
        decoration: BoxDecoration(
          color: _hover? const Color(0x0AFFFFFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(4)
        ),
        padding: const EdgeInsets.symmetric(horizontal: 3),
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
                  decoration: BoxDecoration(
                    color: widget.variable.color,
                    borderRadius: BorderRadius.circular(22)
                  ),
                  child: Transform.rotate(
                    angle: _getIconRotation(),
                    child: Opacity(
                      opacity: _getIconOpacity(),
                      child: const Icon(
                        Symbols.inventory,
                        weight: 300,
                        opticalSize: 20,
                        size: 17,
                        color: DiscordTheme.white,
                        shadows: [Shadow(color: Color(0xAA000000), blurRadius: 3)],
                      )
                    )
                  )
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
                        widget.variable.name, 
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: widget.variable.color,
                          fontSize: 12,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      
                      Text(
                        "\$${widget.variable.keyword}\$", 
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    child: Text(
                      widget.variable.description.isNotEmpty ? widget.variable.description : "No Description.",
                      style: const TextStyle(
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