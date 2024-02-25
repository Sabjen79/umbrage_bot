import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';

class LexiconEventAddMessageWidget extends StatefulWidget {
  final VoidCallback onTap, onDelete;

  const LexiconEventAddMessageWidget({
    required this.onTap,
    required this.onDelete,
    super.key
  });

  @override
  State<LexiconEventAddMessageWidget> createState() => _LexiconEventAddMessageWidgetState();
}

class _LexiconEventAddMessageWidgetState extends State<LexiconEventAddMessageWidget> {
  bool _hoverAdd = false;
  bool _hoverDelete = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: widget.onTap,
            onHover: (b) {
              setState(() {
                _hoverAdd = b;
              });
            },
            child: Container(
              color: _hoverAdd ? DiscordTheme.backgroundColorDarker : DiscordTheme.backgroundColorDarkest,
              height: 30,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 3),
                    child: Icon(
                      Symbols.add,
                      size: 17,
                      opticalSize: 20,
                      color: DiscordTheme.lightGray,
                    )
                  ),

                  Padding(
                    padding: EdgeInsets.only(bottom: 1),
                    child: Text(
                      "Add Message", 
                      style: TextStyle(
                        color: DiscordTheme.lightGray,
                        fontWeight: FontWeight.w500,
                        fontSize: 13
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        

        InkWell(
          onTap: widget.onDelete,
          onHover: (b) {
            setState(() {
              _hoverDelete = b;
            });
          },
          child: Container(
            color: _hoverDelete ? DiscordTheme.backgroundColorDarker : DiscordTheme.backgroundColorDarkest,
            height: 30,
            width: 28,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Icon(
                    Symbols.delete,
                    size: 17,
                    opticalSize: 20,
                    color: _hoverDelete ? Colors.red[700] : DiscordTheme.lightGray,
                  )
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}