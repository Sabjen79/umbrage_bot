import 'package:flutter/material.dart';

class SimpleSwitch extends StatelessWidget {
  final double size;
  final bool value;
  final Function(bool) onChanged;

  const SimpleSwitch({this.size = 50, required this.value, required this.onChanged, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      child: FittedBox(
        fit: BoxFit.fill,
        child: Switch(
          value: value, 
          onChanged: onChanged
        )
      )
    );
  }
}