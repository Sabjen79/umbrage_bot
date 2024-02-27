import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/profile/bot_profile.dart';
import 'package:umbrage_bot/profile/bot_profile_list.dart';
import 'package:umbrage_bot/ui/components/simple_discord_button.dart';
import 'package:umbrage_bot/ui/components/simple_discord_dialog.dart';
import 'package:umbrage_bot/ui/main_menu/windows/bot_profile/bot_profile_route.dart';
import 'package:umbrage_bot/ui/main_menu/windows/console/console_route.dart';
import 'package:umbrage_bot/ui/main_menu/windows/extensions/extensions_route.dart';
import 'package:umbrage_bot/ui/main_menu/windows/lexicon/lexicon_route.dart';
import 'package:umbrage_bot/ui/main_menu/main_menu.dart';
import 'package:umbrage_bot/ui/main_menu/windows/music/music_route.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_menu_router.dart';
import 'package:umbrage_bot/ui/main_menu/windows/settings/settings_route.dart';
import 'package:umbrage_bot/ui/start_menu/add_profile.dart';
import 'package:umbrage_bot/ui/start_menu/profile_widget.dart';

class StartMenu extends StatefulWidget {
  const StartMenu({super.key});

  @override
  State<StartMenu> createState() => _StartMenuState();
}

class _StartMenuState extends State<StartMenu> {
  List<BotProfile> profiles = [];
  List<Widget> profileWidgets = [];
  bool _loaded = false;
  bool _connecting = false;
  String? _botName;

  @override
  void initState() {
    super.initState();

    BotProfileList().loadProfiles().then((value) {
      profiles = value;

      for(var p in profiles) {
        profileWidgets.add(ProfileWidget(p, connectBot, deleteProfile));
      }

      setState(() {
        _loaded = true;
      });
    });
  }

  void connectBot(BotProfile profile) async {
    setState(() {
      _botName = profile.getUsername();
      _connecting = true;
    });

    Timer(const Duration(seconds: 10), () {
      if(_connecting) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return SimpleDiscordDialog(
              cancelText: "",
              submitText: "Exit App",
              onSubmit: () async => {
                exit(0)
              },
              content: const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  width: 300,
                  child: Text(
                    "The bot takes too much time to wake up. Make sure the Lavalink server is opened and try again!",
                    textAlign: TextAlign.center,
                  )
                )
              ),
            );
          }
        );
      }
    });

    await Bot.create(profile);
    
    var router = MainMenuRouter();
    router.addRoute(BotProfileRoute());
    router.addRoute(ConsoleRoute());
    router.addRoute(MusicRoute());
    router.addRoute(LexiconRoute());
    router.addRoute(ExtensionsRoute());
    router.addRoute(SettingsRoute());

    for(final route in router.getMainRoutes()) {
      route.refreshWindows();
    }

    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
        builder: (context) => const MainMenu(),
      )
    );

    setState(() {
      _connecting = false;
    });
  }

  void addProfile(BotProfile profile) async {
    setState(() {
      profiles.add(profile);

      profileWidgets.add(ProfileWidget(profile, connectBot, deleteProfile));
    });
  }

  void deleteProfile(BotProfile p) async {
    await BotProfileList().deleteProfile(p.getId());
    
    setState(() {
      profiles.remove(p);

      for(var w in profileWidgets) {
        if(w is ProfileWidget && w.profile.getId() == p.getId()) {
          profileWidgets.remove(w);
          return;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(!_loaded || _connecting) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _connecting ? Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text(
                  "$_botName is waking up...", 
                  style: const TextStyle(
                    fontWeight: FontWeight.w500, 
                    fontSize: 16
                  )
                )
              ) : Container(),
              const CircularProgressIndicator()
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 25, right: 13),
          child: SimpleDiscordButton(
            width: 70,
            height: 30,
            text: "Add Bot",
            onTap: () => showDialog(
              context: context, 
              builder: (BuildContext context) => AddProfile(addProfile)
            ),
          )
        ),
        body: Center(
          child: () {
            if(profileWidgets.isNotEmpty) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: profileWidgets
              );
            } else {
              return const Text(
                "You have no bots :(\nAdd one!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600
                ),
              );
            }
          }()
        ),
      );
    }
    
  }
}