import 'dart:io';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';

class RandomSoundsItem extends StatefulWidget {
  final File? sound;
  final VoidCallback? onTap;
  final Function(File)? onDelete;

  const RandomSoundsItem({
    required this.sound,
    this.onTap,
    this.onDelete,
    super.key
  });

  @override
  State<RandomSoundsItem> createState() => _RandomSoundsItemState();
}

class _RandomSoundsItemState extends State<RandomSoundsItem> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.ease, reverseCurve: Curves.easeIn));
    
    _animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        _animationController.forward();
      },
      onExit: (_) {
        _animationController.reverse();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(10),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: DiscordTheme.backgroundColorDarker
            ),
            child: InkWell(
              onTap: widget.onTap,
              child: TooltipVisibility(
                visible: widget.sound != null,
                child: Tooltip(
                  message: widget.sound != null ? widget.sound!.path.toString().split('\\').last : "",
                  preferBelow: false,
                  verticalOffset: 50,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: DiscordTheme.white2
                  ),
                  decoration: const BoxDecoration(
                    color: DiscordTheme.black,
                    borderRadius: BorderRadius.all(Radius.circular(3))
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: DiscordTheme.backgroundColorDark,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: (widget.sound == null ? 
                      Center(
                        child: Icon(
                          Symbols.add_box,
                          color: Color.lerp(DiscordTheme.lightGray, DiscordTheme.white2, _animation.value),
                          size: 40.0 + 5*_animation.value,
                          opticalSize: 48,
                          grade: 200,
                          fill: 1,
                        )
                      ) : 
                      Center(
                        child: Icon(
                          Symbols.volume_up,
                          color: Color.lerp(DiscordTheme.lightGray, DiscordTheme.white2, _animation.value),
                          size: 50.0 + 5*_animation.value,
                          opticalSize: 48,
                          grade: 200,
                          fill: 1,
                        )
                      )
                    )
                  ),
                ),
              )
            )
          ),
          (widget.onDelete != null) ? Positioned(
            right: 20,
            top: 20,
            child: Opacity(
              opacity: _animation.value,
              child: InkWell(
                onTap: widget.onDelete == null ? null : () {
                  widget.onDelete!(widget.sound!);
                },
                child: const Icon(
                  Symbols.delete,
                  shadows: [
                    Shadow(
                      color: Color(0xFF000000),
                      blurRadius: 7
                    )
                  ],
                  size: 25,
                  color: Colors.red,
                  fill: 1,
                ),
              ),
            )
          ) : const SizedBox.shrink()
        ],
      )
    );
  }
}