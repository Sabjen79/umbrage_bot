import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';

class LexiconEventVariablePill extends StatefulWidget {
  final String keyword;
  final String name;
  final String description;
  final Color color;

  const LexiconEventVariablePill({
    required this.keyword,
    required this.name,
    required this.description,
    required this.color,
    super.key
  });

  @override
  State<LexiconEventVariablePill> createState() => _LexiconEventVariablePillState();
}

class _LexiconEventVariablePillState extends State<LexiconEventVariablePill> with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation _hoverAnimation;

  @override
  void initState() {
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _hoverAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _hoverController, curve: Curves.ease, reverseCurve: Curves.easeIn));
    _hoverController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.color.withAlpha((_hoverAnimation.value * 50 + 150).toInt()),
        borderRadius: BorderRadius.circular(20)
      ),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 20,
      child: InkWell(
        hoverColor: Colors.transparent,
        onHover: (b) {
          setState(() {
            b ? _hoverController.forward() : _hoverController.reverse();
          });
        },
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: widget.keyword));
        },
        child: IntrinsicWidth(
          child: Tooltip(
            preferBelow: false,
            verticalOffset: 15,
            waitDuration: const Duration(milliseconds: 300),
            richMessage: WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: Container(
                padding: const EdgeInsets.all(2),
                constraints: const BoxConstraints(maxWidth: 250),
                child: Text(
                  widget.description.isEmpty ? "Click to copy keyword to clipboard." : "${widget.description}\n\nClick to copy keyword to clipboard.",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: DiscordTheme.white2
                  ),
                ),
              )
            ),
            decoration: const BoxDecoration(
              color: DiscordTheme.black,
              borderRadius: BorderRadius.all(Radius.circular(3))
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: 1.0 - _hoverAnimation.value,
                  child: Text(
                    widget.name,
                    style: TextStyle(
                      color: widget.color,
                      fontWeight: FontWeight.w500,
                      shadows: const [
                        Shadow(color: Colors.black87, blurRadius: 2)
                      ]
                    ),
                  ),
                ),
                Opacity(
                  opacity: _hoverAnimation.value,
                  child: Text(
                    widget.keyword,
                    style: TextStyle(
                      color: widget.color,
                      fontWeight: FontWeight.w500,
                      shadows: const [
                        Shadow(color: Colors.black87, blurRadius: 2)
                      ]
                    ),
                  ),
                )
              ],
            ),
          )
        )
      )
    );
  }
}