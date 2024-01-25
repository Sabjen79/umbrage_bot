import 'package:umbrage_bot/bot/components/lexicon/variables/lexicon_variable.dart';

mixin LexiconVariableSecondaryValueMixin<T> on LexiconVariable {
  late T _secondaryValue;

  T getSecondaryValue() {
    return _secondaryValue;
  }

  void setSecondaryValue(T value) {
    _secondaryValue = value;
  }
}