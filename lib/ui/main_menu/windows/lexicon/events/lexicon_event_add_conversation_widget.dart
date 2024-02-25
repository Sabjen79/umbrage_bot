import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';

class LexiconEventAddConversationWidget extends StatefulWidget {
  final VoidCallback onTap;

  const LexiconEventAddConversationWidget({
    required this.onTap,
    super.key
  });

  @override
  State<LexiconEventAddConversationWidget> createState() => _LexiconEventAddConversationWidgetState();
}

class _LexiconEventAddConversationWidgetState extends State<LexiconEventAddConversationWidget> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
    onTap: widget.onTap,
    onHover: (b) {
      setState(() {
        _hover = b;
      });
    },
    child: Container(
      color: _hover ? DiscordTheme.backgroundColorDarker : DiscordTheme.backgroundColorDarkest,
      height: 40,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10, right: 3),
            child: Icon(
              Symbols.add,
              size: 25,
              opticalSize: 20,
              color: DiscordTheme.lightGray,
            )
          ),

          Padding(
            padding: EdgeInsets.only(bottom: 1),
            child: Text(
              "Add Conversation", 
              style: TextStyle(
                color: DiscordTheme.lightGray,
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