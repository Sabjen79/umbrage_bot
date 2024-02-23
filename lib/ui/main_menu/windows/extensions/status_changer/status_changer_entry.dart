import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';

class StatusChangerEntry extends StatefulWidget {
  final String initialValue;
  final Function(String) onChanged;
  final VoidCallback onDelete;

  const StatusChangerEntry({
    required this.initialValue,
    required this.onChanged,
    required this.onDelete,
    super.key
  });

  @override
  State<StatusChangerEntry> createState() => _StatusChangerEntryState();
}

class _StatusChangerEntryState extends State<StatusChangerEntry> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;
  late TextEditingController _textController;
  late Widget _textField;
  late _Status _selectedStatus;

  void init() {
    _textController = TextEditingController(text: widget.initialValue.substring(1));

    _textField = TextField(
      controller: _textController,
      inputFormatters: [
        LengthLimitingTextInputFormatter(60),
        FilteringTextInputFormatter.deny(RegExp(r"\n"))
      ],
      decoration: const InputDecoration(
        hintText: "Status",
      ),
      style: const TextStyle(fontSize: 14),
      onChanged: (text) {
        widget.onChanged(_selectedStatus.value + text);
      },
    );

    _selectedStatus = _Status.custom;
    for(final status in _Status.values) {
      if(widget.initialValue[0] == status.value) _selectedStatus = status;
    }
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
  void didUpdateWidget(covariant StatusChangerEntry oldWidget) {
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

            Transform.translate(
              offset: Offset(-10.0 + _animation.value * 20.0, 0),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: DiscordTheme.backgroundColorLight)
                ),
                child: DropdownButton<_Status>(
                  icon: const SizedBox.shrink(),
                  underline: const SizedBox.shrink(),
                  alignment: Alignment.center,
                  isDense: true,
                  value: _selectedStatus,
                  onChanged: (v) {
                    setState(() {
                      _selectedStatus = v!;
                      widget.onChanged(v.value + _textController.text);
                    });
                  },
                  items: _Status.values.map((e) => DropdownMenuItem(
                    value: e, 
                    child: Text(
                      e.name,
                      style: TextStyle(
                        color: e.value == "0" ? DiscordTheme.lightGray : DiscordTheme.white2,
                        fontSize: 14
                      ),
                    )
                  )).toList(),
                )
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

enum _Status {
  custom("0", "Custom"),
  playing("1", "Playing"),
  watching("2", "Watching"),
  listening("3", "Listening to"),
  streaming("4", "Streaming"),
  competing("5", "Competing in");

  const _Status(this.value, this.name);

  final String value;
  final String name;
}