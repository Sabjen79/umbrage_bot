import 'dart:async';

class BotTimer {
  final void Function() _callback;
  final int Function() _getDuration;
  final bool _periodic;

  late Timer timer;
  late DateTime runTime;

  BotTimer._(this._getDuration, this._callback, this._periodic) {
    timer = Timer(Duration.zero, () {});
    _createTimer();
  }

  static BotTimer delayed(int duration, Function() callback) {
    return BotTimer._(() => duration, callback, false);
  }

  static BotTimer periodic(int Function() getDuration, Function() callback) {
    return BotTimer._(getDuration, callback, true);
  }

  void _createTimer() {
    var duration = _getDuration();
    runTime = DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch + duration);
    if(_periodic) {
      if(timer.isActive) timer.cancel();
      timer = Timer(Duration(milliseconds: duration), () {
        _callback();

        _createTimer();
      });
    } else {
      timer = Timer(Duration(milliseconds: duration), _callback); 
    }
  }

  void runEarly() {
    _callback();
    timer.cancel();

    if(_periodic) {
      _createTimer();
    }
  }
}