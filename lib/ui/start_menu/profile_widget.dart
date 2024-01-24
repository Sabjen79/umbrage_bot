import 'package:flutter/material.dart';
import 'package:umbrage_bot/bot/profile/bot_profile.dart';
import 'package:umbrage_bot/ui/components/simple_discord_dialog.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';

class ProfileWidget extends StatefulWidget {
  final BotProfile profile;
  final Function(BotProfile) onTap;
  final Function(BotProfile) onRemove;

  const ProfileWidget(this.profile, this.onTap, this.onRemove, {super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late MenuController _menuController;
  late Animation _animation;


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.ease, reverseCurve: Curves.easeIn));

    _animationController.addListener(() {
      setState(() {});
    });

    _menuController = MenuController();
  }

  void _openMenu(TapDownDetails details) {
    _menuController.open(position: details.localPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (value) {
          setState(() {
            _animationController.forward();
          });
        },
        onExit: (value) {
          setState(() {
            _animationController.reverse();
          });
        },
        child: GestureDetector(
          onTap: () {
            widget.onTap(widget.profile);
          },
          onSecondaryTapDown: _openMenu,
          child: MenuAnchor(
            controller: _menuController,
            anchorTapClosesMenu: true,
            menuChildren: <Widget>[
              MenuItemButton(
                trailingIcon: const Icon(Icons.delete_forever, weight: 0.1),
                onPressed: () {
                  showDialog(
                    context: context, 
                    builder: (BuildContext context) => SimpleDiscordDialog(
                      onSubmit: () { 
                        widget.onRemove(widget.profile);
                        Navigator.pop(context);
                      },
                      submitText: "YES",
                      cancelText: "Actually, no",
                      width: 300,
                      content: SizedBox(
                        width: 300,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                          child: Text(
                            "Are you sure you want to remove ${widget.profile.getUsername()} from this application? 😭😭😭",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    )
                  );
                },
                child: const Text("Remove Bot",),
              ),
            ],
            child: Container(
              transform: Matrix4.translationValues(0, -_animation.value*7.0, 0),
              width: 130,
              height: 160,
              decoration: BoxDecoration(
                color: Color.lerp(
                  DiscordTheme.backgroundColorDarker,
                  DiscordTheme.backgroundColorDarkest,
                  _animation.value
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(25),
                    blurRadius: _animation.value*10.0,
                    spreadRadius: _animation.value*5.0
                  )
                ],
                borderRadius: const BorderRadius.all(Radius.circular(10.0))
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                      child: Image.network(
                        widget.profile.getAvatarUrl(),
                        width: 110,
                        height: 110,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 130,
                    height: 35,
                    child: Center(
                      child: FittedBox(
                        child: Text(
                          widget.profile.getUsername(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      )
                    )
                  )
                ],
              ),
            )
          )
        )
      )
    );
  }

  
}