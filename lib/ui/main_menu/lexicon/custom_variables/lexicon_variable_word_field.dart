import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/ui/main_menu/main_menu.dart';

class LexiconVariableWordField extends StatefulWidget {
  final VoidCallback onDelete;
  final Widget child;

  const LexiconVariableWordField({
    required this.onDelete,
    required this.child,
    super.key
  });

  @override
  State<LexiconVariableWordField> createState() => _LexiconVariableWordFieldState();
}

class _LexiconVariableWordFieldState extends State<LexiconVariableWordField> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.ease, reverseCurve: Curves.easeIn));

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) { setState(() { _controller.forward(); });},
      onExit: (_) { setState(() { _controller.reverse(); });},
      child: Container(
        alignment: Alignment.centerLeft,
        width: double.infinity,
        height: 30,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.centerLeft,
          children: [
            Positioned(
              left: -20.0 + _animation.value * 20.0,
              child: Opacity(
                opacity: _animation.value,
                child: InkWell(
                  splashFactory: NoSplash.splashFactory,
                  onTap: widget.onDelete,
                  hoverColor: Colors.transparent,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0x15FFFFFF),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [BoxShadow(color: Color(0x11000000), blurRadius: 3, spreadRadius: 1, offset: Offset(0, 4))]
                    ),
                    alignment: Alignment.center,
                    width: 17,
                    height: 17,
                    child: const Icon(
                      Symbols.close,
                      size: 15,
                      color: Colors.red,
                    ),
                  ),
                ),
              )
            ),
            
            Positioned(
              left: 5.0 + _animation.value * 20.0,
              top: 4,
              child: SizedBox(
                width: MainMenu.getMainWindowWidth(context),
                child: widget.child,
              ),
            )
          ],
        ),
      )
      
    );
  }
}