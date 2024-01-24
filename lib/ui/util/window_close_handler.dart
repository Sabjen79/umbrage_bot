import 'package:flutter/material.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/ui/components/simple_discord_dialog.dart';

class WindowCloseHandler {
  static bool _isOpen = false;

  static void init(BuildContext context) {
    FlutterWindowClose.setWindowShouldCloseHandler(() async {
      if(_isOpen) return false;
      _isOpen = true;

      return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SimpleDiscordDialog(
            cancelText: "Cancel",
            onCancel: () {
              Navigator.pop(context, false);
              _isOpen = false;
            },
            submitText: "Exit",
            onSubmit: () => {
              Bot().close().then((v) => Navigator.pop(context, true))
            },
            content: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SizedBox(
                width: 300,
                child: Text(
                  "Do you really want to quit?\nThis action will disconnect ${Bot().user.username}!",
                  textAlign: TextAlign.center,
                )
              )
            ),
          );
        }
      );
    });
  }
}