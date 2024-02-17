import 'package:flutter/material.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/profile/bot_profile.dart';
import 'package:umbrage_bot/bot/profile/bot_profile_list.dart';
import 'package:umbrage_bot/ui/main_menu/bot_profile/bot_profile_route.dart';
import 'package:umbrage_bot/ui/main_menu/console/console_route.dart';
import 'package:umbrage_bot/ui/main_menu/lexicon/lexicon_route.dart';
import 'package:umbrage_bot/ui/main_menu/main_menu.dart';
import 'package:umbrage_bot/ui/main_menu/music/music_route.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_menu_router.dart';
import 'package:umbrage_bot/ui/main_menu/settings/settings_route.dart';
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
      setState(() {
        _loaded = true;
        profiles = value;

        for(var p in profiles) {
          profileWidgets.add(ProfileWidget(p, connectBot, deleteProfile));
        }
      });
    });
  }

  void connectBot(BotProfile profile) {
    setState(() {
      _botName = profile.getUsername();
      _connecting = true;
    });

    Bot.create(profile).then((_) async {

      var router = MainMenuRouter();
      router.addRoute(BotProfileRoute());
      router.addRoute(ConsoleRoute());
      router.addRoute(MusicRoute());
      router.addRoute(LexiconRoute());
      router.addRoute(SettingsRoute());

      for(final route in router.getMainRoutes()) {
        await route.refreshWindows();
      }

    }).then((_) {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(
          builder: (context) => const MainMenu(),
        )
      );

      setState(() {
        _connecting = false;
      });
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
          child: ElevatedButton(
            onPressed: () => showDialog(
              context: context, 
              builder: (BuildContext context) => AddProfile(addProfile)
            ),
            child: const Text("Add New Bot"),
          ),
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