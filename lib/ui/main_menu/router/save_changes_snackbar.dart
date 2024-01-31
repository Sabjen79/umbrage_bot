import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:umbrage_bot/ui/components/simple_discord_button.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_menu_router.dart';

class SaveChangesSnackbar extends StatefulWidget {
  const SaveChangesSnackbar({super.key});

  @override
  State<SaveChangesSnackbar> createState() => _SaveChangesSnackbarState();
}

class _SaveChangesSnackbarState extends State<SaveChangesSnackbar> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  late AnimationController _fadeController;
  late Animation _fadeAnimation;

  AsyncCallback? resetAction;
  AsyncCallback? saveAction;
  bool _waiting = false;

  void _onRouteChanged(bool b) {
    _controller.reset();

    if(b) {
      setState(() {
        _controller.forward();
      });
    }
  }

  void _onBlock(bool b, AsyncCallback? r, AsyncCallback? s) {
    resetAction = r;
    saveAction = s;

    if(b) {
      _fadeController.forward();
    } else {
      _fadeController.reverse();
    }
  }

  @override
  void initState() {
    super.initState();

    MainMenuRouter().onRouteChanged(_onRouteChanged);
    MainMenuRouter().blockListener = _onBlock;

    _controller = AnimationController(duration: const Duration(milliseconds: 600), vsync: this)
    ..addListener(() {
      setState(() {});
    });
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    _fadeController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this)
    ..addListener(() {
      setState(() {});
    });
    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(_fadeController);
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeController.dispose();
    MainMenuRouter().removeListener(_onRouteChanged);
    MainMenuRouter().blockListener = null;

    super.dispose();
  }

  double _animationValue() {
    return (_animation.value - 0.5).abs()/0.5;
  }

  double _randomAnimationValue() {
    if(_animation.value > 0.95 || _animation.value < 0.05) return 0;
    return 10 * Random().nextDouble()* pow(_animationValue(), 2);
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: _fadeAnimation.value == 0,
      child: Opacity(
        opacity: _fadeAnimation.value,
        child: Container(
          margin: EdgeInsets.only(
            bottom: _randomAnimationValue() + _fadeAnimation.value * 10,
            left: _randomAnimationValue(),
            right: _randomAnimationValue()
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          width: MediaQuery.of(context).size.width/2,
          height: 42,
          decoration: BoxDecoration(
            color: Color.lerp(DiscordTheme.black, Colors.red, 1 - _animationValue()),
            borderRadius: const BorderRadius.all(Radius.circular(4))
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Expanded(
                child: Text(
                  "You have unsaved changes!",
                  style: TextStyle(
                    color: DiscordTheme.white2,
                    fontSize: 12
                  ),
                )
              ),
              InkWell(
                onTap: _waiting ? null : () async {
                  if(resetAction != null) await resetAction!();
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text("Reset", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
                )
              ),
              SimpleDiscordButton(
                width: 90,
                height: 30,
                color: const Color(0xFF248046),
                text: "Save Changes",
                loadingAnimation: true,
                onTap: _waiting ? null : () async {
                  setState(() { _waiting = true; });
                  if(saveAction != null) await saveAction!();
                  setState(() { _waiting = false; });
                },
              )
            ],
          ),
        )
      )
    );
  }
}