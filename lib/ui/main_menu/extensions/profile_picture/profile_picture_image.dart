import 'dart:io';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';

class ProfilePictureImage extends StatefulWidget {
  final File? image;
  final VoidCallback? onTap;
  final Function(File)? onDelete;

  const ProfilePictureImage({
    required this.image,
    this.onTap,
    this.onDelete,
    super.key
  });

  @override
  State<ProfilePictureImage> createState() => _ProfilePictureImageState();
}

class _ProfilePictureImageState extends State<ProfilePictureImage> with SingleTickerProviderStateMixin {
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
              child: Container(
                decoration: BoxDecoration(
                  color: DiscordTheme.backgroundColorDark,
                  borderRadius: BorderRadius.circular(10)
                ),
                clipBehavior: Clip.antiAlias,
                child: (widget.image == null ? 
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
                  Image.file(
                    widget.image!,
                    fit: BoxFit.cover,
                    isAntiAlias: true,
                    filterQuality: FilterQuality.medium,
                  )
                )
              ),
            )
          ),
          (widget.onDelete != null) ? Positioned(
            right: 20,
            top: 20,
            child: Opacity(
              opacity: _animation.value,
              child: InkWell(
                onTap: widget.onDelete == null ? null : () {
                  widget.onDelete!(widget.image!);
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