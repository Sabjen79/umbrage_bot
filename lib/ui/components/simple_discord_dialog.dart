import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:umbrage_bot/ui/components/simple_discord_button.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';

class SimpleDiscordDialog extends StatefulWidget {
  final Widget content;
  final double width;
  final String cancelText;
  final String submitText;
  final VoidCallback? onCancel;
  final AsyncCallback? onSubmit;

  final bool disableSubmit;
  final bool enableLoadingAnimation;

  const SimpleDiscordDialog({
    required this.content,
    this.width = 300,
    this.cancelText = "Close",
    this.submitText = "Submit",
    this.onCancel,
    this.onSubmit,
    this.disableSubmit = false,
    this.enableLoadingAnimation = false,
    super.key
  });

  @override
  State<SimpleDiscordDialog> createState() => _SimpleDiscordDialogState();
}

class _SimpleDiscordDialogState extends State<SimpleDiscordDialog> {
  bool _cancelButtonHover = false;

  @override 
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.content,
          Container(
            decoration: const BoxDecoration(
              color: DiscordTheme.backgroundColorDark,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(3),
                bottomRight: Radius.circular(3)
              )
            ),
            width: widget.width,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                InkWell(
                  onTap: widget.onCancel ?? () { Navigator.pop(context); },
                  onHover: (b) { setState(() {
                    _cancelButtonHover = b;
                  }); },
                  child: Text(
                    widget.cancelText, 
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      decoration: _cancelButtonHover ? TextDecoration.underline : null,
                      decorationThickness: 3,
                    )
                  )
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SimpleDiscordButton(
                    width: 90,
                    height: 24,
                    text: widget.submitText,
                    loadingAnimation: widget.enableLoadingAnimation,
                    onTap: (widget.disableSubmit) ? null : widget.onSubmit,
                  )
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}