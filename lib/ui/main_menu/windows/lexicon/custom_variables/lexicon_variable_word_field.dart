import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter/services.dart';

class LexiconVariableWordField extends StatefulWidget {
  final String initialText;
  final Function(String) onChanged;
  final VoidCallback onDelete;
  
  const LexiconVariableWordField({
    required this.onChanged,
    required this.onDelete,
    this.initialText = "",
    super.key
  });

  @override
  State<LexiconVariableWordField> createState() => _LexiconVariableWordFieldState();
}

class _LexiconVariableWordFieldState extends State<LexiconVariableWordField> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  late TextEditingController _textController;
  late Widget _textField;

  void init() {
    _textController = TextEditingController(
      text: widget.initialText
    );

    _textField = TextField(
      controller: _textController,
      minLines: 1,
      maxLines: 2,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r"\n"))
      ],
      decoration: const InputDecoration(
        hintText: "Word"
      ),
      style: const TextStyle(fontSize: 14),
      onChanged: widget.onChanged,
    );
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.ease, reverseCurve: Curves.easeIn));

    _controller.addListener(() {
      setState(() {});
    });

    init();
  }

  @override
  void didUpdateWidget(covariant LexiconVariableWordField oldWidget) {
    super.didUpdateWidget(oldWidget);

    init();
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
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
      )
      
    );
  }
}