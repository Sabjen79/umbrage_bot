import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SimpleChanceField extends StatefulWidget {
  final double chance;
  final Function(double) onChanged;

  const SimpleChanceField({required this.chance, required this.onChanged, super.key});

  @override
  State<SimpleChanceField> createState() => _SimpleChanceFieldState();
}

class _SimpleChanceFieldState extends State<SimpleChanceField> {
  late double _chance;
  late TextEditingController _chanceController;

  String _chanceString() => _chance > 0.999 ? (_chance*100).toStringAsFixed(0) : (_chance*100).toStringAsFixed(2);

  @override
  void initState() {
    super.initState();

    _chance = widget.chance;
    _chanceController = TextEditingController(text: _chanceString());
  }

  @override
  void didUpdateWidget(covariant SimpleChanceField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if(widget.chance != oldWidget.chance) {
      _chance = widget.chance;
      _chanceController.text = _chanceString();
    }
  }

  @override
  void dispose() {
    _chanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Slider(
              value: _chance,
              max: 1.0,
              onChanged: (v) {
                setState(() {
                  _chance = double.parse(v.toStringAsFixed(2));
                  _chanceController.text = _chanceString();
                });
              },
              onChangeEnd: (v) {
                widget.onChanged(_chance);
              },
            )
          ),
          SizedBox(
            width: 75,
            child: TextField(
              maxLength: 5,
              textAlign: TextAlign.end,
              controller: _chanceController,
              decoration: const InputDecoration(
                suffixText: "%",
                counter: SizedBox(),
              ),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^(100(?:\.(0)*)?|\d?\d(?:\.\d*?)?)$'), replacementString: "error"),
              ],
              onChanged: (v) {
                if(v == "error") {
                  _chanceController.text = _chanceString();
                  return;
                }

                setState(() {
                  _chance = v.isEmpty ? 0 : double.parse(v)/100.0;
                });

                widget.onChanged(_chance);
              },
            ),
          )
          
        ]
      )
    );
  }
}