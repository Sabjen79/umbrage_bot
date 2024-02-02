import 'dart:ui';

abstract class LexiconVariable {
  final String _keyword;
  final String _name;
  final String _description;
  final int _color;

  String getKeyword() => _keyword;
  String getName() => _name;
  String getDescription() => _description;
  int getColorInt() => _color;
  Color getColor() => Color(_color);

  LexiconVariable(this._keyword, this._name, this._description, this._color);

  String getValue();
}