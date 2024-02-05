import 'dart:ui';

abstract class LexiconVariable {
  final String _keyword;
  final String _name;
  final String _description;
  final int _color;

  String get keyword => _keyword;
  String get name => _name;
  String get description => _description;
  int get colorInt => _color;
  Color get color => Color(_color);

  LexiconVariable(this._keyword, this._name, this._description, this._color);

  String getValue();
}