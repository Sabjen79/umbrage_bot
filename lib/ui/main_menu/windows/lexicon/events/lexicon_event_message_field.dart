import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:rich_text_controller/rich_text_controller.dart';
import 'package:umbrage_bot/bot/lexicon/conversation/conversation_message.dart';
import 'package:umbrage_bot/bot/lexicon/variables/lexicon_variable.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';

class LexiconEventMessageField extends StatefulWidget {
  final List<LexiconVariable> variables;
  final ConversationMessage message;
  final Function(int, String) onChanged;
  final VoidCallback onDelete;
  
  const LexiconEventMessageField({
    required this.variables,
    required this.onChanged,
    required this.onDelete,
    required this.message,
    super.key
  });

  @override
  State<LexiconEventMessageField> createState() => _LexiconEventMessageFieldState();
}

class _LexiconEventMessageFieldState extends State<LexiconEventMessageField> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  late RichTextController _textController;
  late _Type _type;
  late Widget _textField;

  void init() {
    Map<RegExp, TextStyle> matches = {};

    for(var v in widget.variables) {
      matches[RegExp("\\\$${v.keyword}\\\$")] = TextStyle(color: v.color, fontWeight: FontWeight.w500);
    }

    _textController = RichTextController(
      onMatch: (l) {},
      patternMatchMap: matches,
      deleteOnBack: false,
      text: widget.message.message
    );

    _type = _Type.values.firstWhere((element) => element.value == widget.message.type);

    initTextField();
  }

  void initTextField() {
    _textField = TextField(
      controller: _textController,
      minLines: 1,
      maxLines: 5,
      inputFormatters: [
        LengthLimitingTextInputFormatter(_type.value == 2 ? 2 : -1),
        FilteringTextInputFormatter.deny(RegExp(r"\n"))
      ],
      decoration: InputDecoration(
        hintText: widget.message.type == 0 ? "Message" : "Emoji"
      ),
      style: const TextStyle(fontSize: 14),
      onChanged: (value) {
        widget.onChanged(_type.value, value);
      },
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
  void didUpdateWidget(covariant LexiconEventMessageField oldWidget) {
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

            Transform.translate(
              offset: Offset(-10.0 + _animation.value * 20.0, 0),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: DiscordTheme.backgroundColorLight)
                ),
                child: DropdownButton<_Type>(
                  icon: const SizedBox.shrink(),
                  underline: const SizedBox.shrink(),
                  alignment: Alignment.center,
                  isDense: true,
                  value: _type,
                  onChanged: (v) {
                    setState(() {
                      _type = v!;
                      widget.onChanged(_type.value, _textController.text);
                      initTextField();
                      _textController.text = "";
                    });
                  },
                  items: _Type.values.map((e) => DropdownMenuItem(
                    value: e, 
                    child: Text(
                      e.name,
                      style: const TextStyle(
                        color: DiscordTheme.white2,
                        fontSize: 14
                      ),
                    )
                  )).toList(),
                )
              )
            ),
            
            _type.value == 1 ? const SizedBox.shrink() : Expanded(
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

enum _Type {
  message(0, "Message"),
  wait(1, "Wait for Response"),
  reaction(2, "Reaction");

  const _Type(this.value, this.name);

  final int value;
  final String name;
}