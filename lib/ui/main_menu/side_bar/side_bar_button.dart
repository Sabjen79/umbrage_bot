import 'dart:math';

import 'package:flutter/material.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';

class SideBarButton extends StatefulWidget {
  final String? label;
  final IconData? icon;
  final bool isActive;
  final VoidCallback? onTap;
  final Widget? child;

  const SideBarButton({
    super.key,
    this.label,
    this.icon,
    this.isActive = false,
    this.onTap,
    this.child,
  });

  @override
  State<SideBarButton> createState() => _SideBarButtonState();
}

class _SideBarButtonState extends State<SideBarButton> with TickerProviderStateMixin {
  late AnimationController _hoverAnimationController;
  late AnimationController _activeAnimationController;
  late Animation _hoverAnimation;
  late Animation _activeAnimation;

  bool _hover = false;

  double _pairedAnimationValue() {
    return min(_activeAnimation.value + _hoverAnimation.value, 1);
  }

  @override
  void initState() {
    super.initState();

    _hoverAnimationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _activeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _hoverAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _hoverAnimationController, curve: Curves.ease, reverseCurve: Curves.easeIn));
    _activeAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _activeAnimationController, curve: Curves.ease, reverseCurve: Curves.easeIn));
  
    _hoverAnimationController.addListener(() {
      setState(() {});
    });

    _activeAnimationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _hoverAnimationController.dispose();
    _activeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      widget.isActive ? _activeAnimationController.forward() : _activeAnimationController.reverse();
    });
    
    return SizedBox(
      width: 60,
      height: 45,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            left: 0,
            child: Container(
              width: 3 * _pairedAnimationValue(),
              height: 30 * min(_activeAnimation.value + _hoverAnimation.value * 0.5, 1),
              decoration: const BoxDecoration(
                color: DiscordTheme.white2,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(3),
                  bottomRight: Radius.circular(3)
                )
              ),
            )
          ),
          InkWell(
            onHover: (b) {
              setState(() {
                _hover = b;
                b ? _hoverAnimationController.forward() : _hoverAnimationController.reverse();
              });
            },
            onTap: widget.onTap,
            child: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color.lerp(DiscordTheme.backgroundColorDark, DiscordTheme.primaryColor, _pairedAnimationValue()),
                borderRadius: BorderRadius.all(Radius.circular(20 - 5 * _pairedAnimationValue()))
              ),
              child: Center(
                child: () {
                  if(widget.child == null) return Icon(widget.icon, weight: 300, grade: -25, opticalSize: 24, color: DiscordTheme.white2);

                  return widget.child;
                }(),
              ),
            ),
          ),
          () {
            if(widget.label == null) return Container();

            return Positioned(
              left: 65,
              child: Container(
                transform: Matrix4( // ScaleX
                  _hover ? 0.95 + 0.05 * _hoverAnimation.value: 0, 0, 0, 0,
                  0, _hover ? 0.95 + 0.05 * _hoverAnimation.value: 0, 0, 0,
                  0, 0, 1, 0,
                  0, 0, 0, 1,
                ),
                decoration: const BoxDecoration(
                  color: DiscordTheme.black,
                  borderRadius: BorderRadius.all(Radius.circular(3))
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                  child: Text(
                    widget.label!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12
                    ),
                  ),
                ),
              ),
            );
          }(),
        ],
      )
    );
  }
}