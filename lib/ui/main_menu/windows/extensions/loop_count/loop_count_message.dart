import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

class LoopCountMessage extends StatefulWidget {
  final String initialValue;
  final Function(String) onChanged;
  final VoidCallback onDelete;

  const LoopCountMessage({
    required this.initialValue,
    required this.onChanged,
    required this.onDelete,
    super.key
  });

  @override
  State<LoopCountMessage> createState() => _LoopCountMessageState();
}

class _LoopCountMessageState extends State<LoopCountMessage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;
  late TextEditingController _textController;
  late Widget _textField;

  void init() {
    _textController = TextEditingController(text: widget.initialValue);

    _textField = TextField(
      controller: _textController,
      inputFormatters: [
        LengthLimitingTextInputFormatter(150),
        FilteringTextInputFormatter.deny(RegExp(r"\n"))
      ],
      decoration: const InputDecoration(
        hintText: "Message",
      ),
      style: const TextStyle(fontSize: 14),
      onChanged: (text) {
        widget.onChanged(text);
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _animationController.addListener(() => setState(() {}));
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.ease, reverseCurve: Curves.easeIn));

    init();
  }

  @override
  void didUpdateWidget(covariant LoopCountMessage oldWidget) {
    super.didUpdateWidget(oldWidget);

    init();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _animationController.forward(),
      onExit:  (_) => _animationController.reverse(),
      child: Container(
        alignment: Alignment.centerLeft,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Transform.translate(
              offset: Offset(-20.0 + _animation.value * 25.0, 0),
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

            Expanded(
              child: Transform.translate(
                offset: Offset(-10.0 + _animation.value * 20.0, 0),
                child: Padding(
                  padding: EdgeInsets.only(right: _animation.value * 10.0),
                  child: _textField,
                )
              )
            )
          ],
        ),
      ),
    );
  }
}