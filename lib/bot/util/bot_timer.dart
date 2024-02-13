import 'dart:async';

class BotTimer {
  final void Function() _callback;
  final Timer timer;
  late final DateTime runTime;

  BotTimer(Duration duration, this._callback) : timer = Timer(duration, _callback) {
    runTime = DateTime.fromMillisecondsSinceEpoch(duration.inMilliseconds + DateTime.now().millisecondsSinceEpoch);
  }

  void runEarly() {
    timer.cancel();

    _callback();
  }
}