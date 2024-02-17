import 'dart:async';

class StreamableStringBuffer extends StringBuffer {
  final StreamController<String> _onChangedStreamController = StreamController<String>.broadcast();

  Stream<String> get onChanged => _onChangedStreamController.stream;

  @override
  void write(Object? object) {
    super.write(object);
    _onChangedStreamController.add(toString());
  }
}