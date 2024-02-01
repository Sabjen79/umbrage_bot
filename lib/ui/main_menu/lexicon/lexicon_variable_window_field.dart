import 'package:flutter/material.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';

class LexiconVariableWindowField extends StatefulWidget {
  final Function(String) onChanged;
  final String initialText;
  final int maxLength;
  final double fontSize;
  final Color color;
  final String hintText;
  final bool isKeyword;
  final bool hasShadow;

  const LexiconVariableWindowField({
    required this.initialText,
    required this.onChanged,
    this.maxLength = 100,
    this.fontSize = 14,
    this.color = DiscordTheme.white,
    this.hintText = "",
    this.isKeyword = false,
    this.hasShadow = false,
    super.key
  });

  @override
  State<LexiconVariableWindowField> createState() => _LexiconVariableWindowFieldState();
}

class _LexiconVariableWindowFieldState extends State<LexiconVariableWindowField> {
  late TextEditingController _controller;
  late String _text;
  bool _hover = false;

  @override
  void initState() {
    super.initState();

    _text = widget.initialText;
    _controller = TextEditingController(text: _text);
  }

  @override
  void didUpdateWidget(covariant LexiconVariableWindowField oldWidget) {
    super.didUpdateWidget(oldWidget);

    _text = widget.initialText;
    _controller = TextEditingController(text: _text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        IntrinsicWidth(
          child: MouseRegion(
            onEnter: (b) { setState(() { _hover = true; });},
            onExit: (b) { setState(() { _hover = false; });},
            child: TextField(
              onChanged: (value) {
                if(value != _text) {
                  setState(() { _text = value; });
                  widget.onChanged(value);
                }
              },
              keyboardType: TextInputType.text,
              maxLines: null,
              textAlignVertical: TextAlignVertical.top,
              controller: _controller,
              maxLength: widget.maxLength,
              decoration: InputDecoration(
                prefixText: widget.isKeyword ? "\$ " : "",
                suffixText: widget.isKeyword ? "\$" : "",
                contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                enabledBorder: !_hover ? null : OutlineInputBorder(
                  borderSide: BorderSide(color: widget.color, width: 1),
                ),
                fillColor: Colors.transparent,
                hintText: _controller.text.isEmpty ? widget.hintText : "",
                hintStyle: TextStyle(color: Color.lerp(widget.color, Colors.black, 0.2)),
                counter: const SizedBox()
              ),
              style: TextStyle(
                shadows: !widget.hasShadow ? [] : const [
                  Shadow(
                    color: Color(0xCC000000),
                    blurRadius: 3,
                    offset: Offset(0, 1)
                  )
                ],
                color: widget.color,
                fontSize: widget.fontSize,
                fontWeight: FontWeight.w500
              ),
            )
          )
        )
      ],
    );
  }
}