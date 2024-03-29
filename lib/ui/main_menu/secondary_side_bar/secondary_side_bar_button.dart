import 'package:flutter/material.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';

class SecondarySideBarButton extends StatefulWidget {
  final String name;
  final bool isActive;
  final IconData icon;
  final VoidCallback onTap;

  const SecondarySideBarButton({
    required this.name,
    required this.onTap,
    required this.icon,
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
          widget.onTap();
        },
        onHover: (b) {
          setState(() {
            _hover = b;
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 3),
              child: Icon(
                widget.icon,
                fill: 1,
                size: 20,
                opticalSize: 10,
                grade: 200,
                weight: 200,
                color: DiscordTheme.lightGray,
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 1, bottom: 1.5),
                child: Text(
                  widget.name,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Color.lerp(DiscordTheme.lightGray, DiscordTheme.white2, hoverActiveValue()),
                    fontSize: 13,
                    fontWeight: FontWeight.w500
                  )
                )
              )
            )
            
          ],
        ),
      ),
    );
  }
}
