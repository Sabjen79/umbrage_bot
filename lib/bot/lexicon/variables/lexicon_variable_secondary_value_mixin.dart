import 'package:umbrage_bot/bot/lexicon/variables/lexicon_variable.dart';

mixin LexiconVariableSecondaryValueMixin<T> on LexiconVariable {
  T? _secondaryValue;

  T? getSecondaryValue() {
    return _secondaryValue;
  }

  void setSecondaryValue(T value) {
    _secondaryValue = value;
  }
}