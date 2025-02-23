import 'dart:async';

import 'package:rxdart/rxdart.dart';

abstract interface class GameTimerService {
  Stream<int> get timer;
  bool get paused;
  void start();
  void togglePause();
  Future<void> close();
}

class GameTimerServiceImpl implements GameTimerService {
  bool _paused = false;
  final _timer = BehaviorSubject<int>.seeded(0);
  final _killSignal = PublishSubject<int>();

  int get _secondsElapsed => _timer.value;

  Stream<int> _getInterval() => Stream.periodic(
    const Duration(seconds: 1),
    (_) => _secondsElapsed + 1,
  ).takeUntil(_killSignal);

  @override
  bool get paused => _paused;

  @override
  Stream<int> get timer => _timer.stream;

  @override
  void start() {
    _paused = false;
    _timer.add(0);
    _timer.sink.addStream(_getInterval().takeWhile((_) => !_paused));
  }

  @override
  void togglePause() {
    _paused = !_paused;

    if (!_paused) {
      _timer.sink.addStream(_getInterval().takeWhile((_) => !_paused));
    }
  }

  @override
  Future<void> close() async {
    _killSignal.add(0);
    await _timer.drain<dynamic>();
    await _timer.close();
  }
}
