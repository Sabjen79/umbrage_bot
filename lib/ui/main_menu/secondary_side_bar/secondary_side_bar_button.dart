import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';

class SecondarySideBarButton extends StatefulWidget {
  final String name;
  final bool isActive;
  final int index;
  final Function(int) onTap;

  const SecondarySideBarButton({
    required this.name,
    required this.index,
    required this.onTap,
    this.isActive = false,
    super.key
  });

  @override
  State<SecondarySideBarButton> createState() => _SecondarySideBarButtonState();
}

class _SecondarySideBarButtonState extends State<SecondarySideBarButton> {
  bool _hover = false;

  double hoverActiveValue() {
    return widget.isActive ? 1 : (_hover ? 0.5 : 0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 25,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        color: Color.lerp(const Color(0x00404249), const Color(0xFF404249), hoverActiveValue())
      ),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      child: InkWell(
        onTap: () {
          widget.onTap(widget.index);
        },
        onHover: (b) {
          setState(() {
            _hover = b;
          });
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Positioned(
              left: 3,
              child: Icon(
                Symbols.tag,
                size: 20,
                opticalSize: 20,
                grade: 200,
                weight: 100,
                color: DiscordTheme.lightGray,
              ),
            ),
            Positioned(
              left: 25,
              top: 1.2,
              child: Text(
                widget.name,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Color.lerp(DiscordTheme.lightGray, DiscordTheme.white2, hoverActiveValue()),
                  fontSize: 13,
                  fontWeight: FontWeight.w500
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
