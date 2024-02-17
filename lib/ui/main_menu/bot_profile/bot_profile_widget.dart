import 'package:flutter/material.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/ui/components/simple_discord_button.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';
import 'package:url_launcher/url_launcher.dart';

class BotProfileWidget extends MainWindow {
  const BotProfileWidget({super.key}) : super(name: "Profile", route: "profile");

  @override
  State<BotProfileWidget> createState() => _BotProfileWidgetState();
}

class _BotProfileWidgetState extends State<BotProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 20,
          right: 20,
          child: SimpleDiscordButton(
            width: 80,
            height: 30,
            text: "Invite Bot",
            onTap: () async {
              await launchUrl(Uri.parse("https://discord.com/oauth2/authorize?client_id=${Bot().user.id}&permissions=8&scope=bot"));
            },
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 125,
              height: 125,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(62),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xAA000000),
                    spreadRadius: 1,
                    blurRadius: 10
                  )
                ]
              ),
              child: Image.network(Bot().user.avatar.url.toString()),
            ),
            const SizedBox(height: 5),
            Text(
              Bot().user.globalName == null ? Bot().user.username : Bot().user.globalName!,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 30,
                shadows: [
                  Shadow(
                    color: Color(0xAA000000),
                    blurRadius: 3,
                    offset: Offset(0, 2)
                  )
                ]
              ),
            ),
            const SizedBox(height: 5),
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  color: DiscordTheme.white2
                ),
                text: "Running on ",
                children: [
                  TextSpan(
                    text: "UmbrageBot",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: DiscordTheme.primaryColor
                    )
                  )
                ]
              ),
            ),
            const SizedBox(height: 50),
          ],
        )
      ],
    );
  }
}