class PseudoRandomIndex {
  final int _length;
  late final List<int> _indexes;
  int _currentIndex = -1;
  
  PseudoRandomIndex(this._length) {
    _indexes = List.generate(_length, (index) => index)..shuffle();
  }

  int getNextIndex() {
    _currentIndex++;
    if(_currentIndex == _length) {
      _indexes.shuffle();
      _currentIndex = 0;
    }

    return _indexes[_currentIndex];
  }
}