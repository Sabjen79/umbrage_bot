import 'package:flutter/material.dart';

abstract class LexiconVariable {
  String token;
  String name;
  String description;
  Color color;

  LexiconVariable(this.token, this.name, this.description, {this.color = Colors.grey});

  String computeVariable();
}