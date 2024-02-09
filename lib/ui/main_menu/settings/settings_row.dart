import 'package:flutter/material.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';

mixin SettingsRow {
  List<Widget> settingsRow({required String name, required String description, required Widget child}) {
    return [
      Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
        width: double.infinity, 
        height: 1, 
        color: DiscordTheme.gray
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: DiscordTheme.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500
                    )
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      color: DiscordTheme.white2,
                      fontSize: 10,
                      fontWeight: FontWeight.w400
                    )
                  )
                ],
              ),
            ),

            Container(
              width: 300,
              alignment: Alignment.centerRight,
              child: child,
            )
          ],
        )
      ),
    ];
  }
}