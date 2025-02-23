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
  bool _paused = true;
  final _timer = BehaviorSubject<int>.seeded(0);
  final _killSignal = PublishSubject<int>();
  final _timeSetter = PublishSubject<int>();

  int get _secondsElapsed => _timer.value;

  Stream<int> _genTimerStream() => Rx.merge([
    _timeSetter,
    Stream.periodic(const Duration(seconds: 1), (_) => _secondsElapsed + 1),
  ]).takeUntil(_killSignal);

  @override
  bool get paused => _paused;

  @override
  Stream<int> get timer => _timer.stream;

  @override
  void start() {
    final oldPaused = _paused;
    _paused = false;
    if (oldPaused) {
      _timer.sink.addStream(_genTimerStream().takeWhile((_) => !_paused));
    }
    _timeSetter.add(0);
  }

  @override
  void togglePause() {
    _paused = !_paused;

    if (!_paused) {
      _timer.sink.addStream(_genTimerStream().takeWhile((_) => !_paused));
    }
  }

  @override
  Future<void> close() async {
    _killSignal.add(0);
    _paused = true;
    await _timer.drain<dynamic>();
    await _timer.close();
  }
}
