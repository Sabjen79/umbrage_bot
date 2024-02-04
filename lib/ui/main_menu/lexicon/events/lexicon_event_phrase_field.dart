import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:rich_text_controller/rich_text_controller.dart';
import 'package:umbrage_bot/bot/lexicon/variables/lexicon_variable.dart';

class LexiconEventPhraseField extends StatefulWidget {
  final List<LexiconVariable> variables;
  final String initialText;
  final Function(String) onChanged;
  final VoidCallback onDelete;
  
  const LexiconEventPhraseField({
    required this.variables,
    required this.onChanged,
    required this.onDelete,
    this.initialText = "",
    super.key
  });

  @override
  State<LexiconEventPhraseField> createState() => _LexiconEventPhraseFieldState();
}

class _LexiconEventPhraseFieldState extends State<LexiconEventPhraseField> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  late RichTextController _textController;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.ease, reverseCurve: Curves.easeIn));

    _controller.addListener(() {
      setState(() {});
    });

    Map<RegExp, TextStyle> matches = {};

    for(var v in widget.variables) {
      matches[RegExp("\\\$${v.getKeyword()}\\\$")] = TextStyle(color: v.getColor(), fontWeight: FontWeight.w500);
    }

    _textController = RichTextController(
      onMatch: (l) {},
      patternMatchMap: matches,
      deleteOnBack: true,
      text: widget.initialText
    );
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
                  child: TextField(
                    controller: _textController,
                    minLines: 1,
                    maxLines: 5,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r"\n"))
                    ],
                    decoration: const InputDecoration(
                      hintText: "Phrase"
                    ),
                    style: const TextStyle(fontSize: 14),
                    onChanged: widget.onChanged,
                  ),
                )
              )
            )
          ],
        ),
      )
      
    );
  }
}