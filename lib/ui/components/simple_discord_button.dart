import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';

class SimpleDiscordButton extends StatefulWidget {
  final double width, height;
  final Color color;
  final AsyncCallback? onTap;
  final String text;
  final bool loadingAnimation;

  const SimpleDiscordButton({
    required this.width, 
    required this.height, 
    required this.text, 
    this.onTap, 
    this.color = DiscordTheme.primaryColor, 
    this.loadingAnimation = false,
    super.key
  });

  @override
  State<SimpleDiscordButton> createState() => _SimpleDiscordButtonState();
}

class _SimpleDiscordButtonState extends State<SimpleDiscordButton> {
  bool _hover = false;
  bool _pressed = false;
  bool _loading = false;

  Color _computeColor() {
    if(_loading || widget.onTap == null) return DiscordTheme.backgroundColorDarker;
    if(_pressed) return Color.lerp(widget.color, Colors.black, 0.3)!;
    if(_hover) return Color.lerp(widget.color, Colors.black, 0.15)!;
    return widget.color;
  }

  @override
  Widget build(BuildContext buildContext) {
    return InkWell(
      onHover: widget.onTap == null ? null : (b) {
        setState(() { 
          _hover = b; 
          if(!b) _pressed = false;
        });
      },
      onTapDown: widget.onTap == null ? null : (d) {
        setState(() { _pressed = true; });
      },
      onTapUp: widget.onTap == null ? null : (d) {
        setState(() { _pressed = false; });
      },
      onTap: widget.onTap == null ? null : () async {
        setState(() { 
          _pressed = false;
          if(widget.loadingAnimation) _loading = true; 
        });
        await widget.onTap!();
        setState(() { _loading = false; });
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: _computeColor(),
          borderRadius: const BorderRadius.all(Radius.circular(4))
        ),
        child: Center(
          child: _loading ?
            SizedBox(
              width: widget.height*0.6,
              height: widget.height*0.6,
              child: CircularProgressIndicator(color: widget.color, strokeWidth: 2),
            ) :
            Text(
              widget.text,
              softWrap: false,
              style: const TextStyle(
                color: DiscordTheme.white2,
                fontSize: 11
              )
            ),
        )
      )
    );
  }
}