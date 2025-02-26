import 'dart:async';

import 'package:rxdart/rxdart.dart';

abstract interface class GameTimerService {
  Stream<int> get timer;
  bool get paused;
  void start([int initSeconds = 0]);
  void togglePause();
  Future<void> close();
}

class GameTimerServiceImpl implements GameTimerService {
  GameTimerServiceImpl([Duration tickDuration = const Duration(seconds: 1)])
      : _timerSubject = BehaviorSubject<int>(),
        _tickDuration = tickDuration;
  late final Duration _tickDuration;
  var _running = false;
  Timer? _ticksTimer;
  final BehaviorSubject<int> _timerSubject;

  @override
  Stream<int> get timer => _timerSubject.stream;

  @override
  bool get paused => !_running;

  @override
  void start([int initialSeconds = 0]) {
    if (initialSeconds < 0) {
      throw RangeError('timer needs a positive number');
    }

    _timerSubject.value = initialSeconds;

    _running = true;
    _startTimer();
  }

  void _startTimer() {
    _ticksTimer?.cancel();
    _ticksTimer = Timer.periodic(_tickDuration, (_) {
      if (_running) {
        _timerSubject.sink.add(_timerSubject.value + 1);
      }
    });
  }

  @override
  void togglePause() {
    _running = !_running;
  }

  @override
  Future<void> close() async {
    _running = false;
    _ticksTimer?.cancel();
    await _timerSubject.close();
  }
}
