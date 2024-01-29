import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';

class SimpleFormField extends StatelessWidget {
  final double width;
  final TextFormField field;
  final String? tooltip;
  final String label;

  const SimpleFormField(this.label, {required this.field, this.tooltip, this.width = 300, super.key});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 2, bottom: 6),
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "$label ",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: DiscordTheme.white2,
                    fontSize: 12
                  ),
                ),
                () {
                  if(tooltip == null) return Container();
                  return Tooltip(
                    message: tooltip,
                    child: const Icon(
                      Symbols.info,
                      size: 12,
                    ),
                  );
                }()
              ],
            )
          ),
          field
        ],
      )
    );
  }
}