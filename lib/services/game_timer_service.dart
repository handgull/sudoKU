import 'dart:async';

abstract interface class GameTimerService {
  Stream<int> get timer;
  bool get paused;
  void start();
  void togglePause();
  void close();
}

class GameTimerServiceImpl implements GameTimerService {
  GameTimerServiceImpl() {
    _stream =
        Stream<int>.periodic(
          const Duration(seconds: 1),
          (x) => _elapsedSeconds + 1,
        ).asBroadcastStream();
  }

  late Stream<int> _stream;
  StreamSubscription<int>? _subscription;
  int _elapsedSeconds = 0;
  bool _paused = false;
  final _controller = StreamController<int>.broadcast();

  @override
  bool get paused => _paused;

  @override
  Stream<int> get timer => _controller.stream;

  @override
  void start() {
    _subscription?.cancel();
    _subscription = null;
    _elapsedSeconds = 0;
    _paused = false;
    _controller.add(_elapsedSeconds);

    _subscription = _stream.listen((seconds) {
      if (!_paused) {
        _elapsedSeconds = seconds;
        _controller.add(_elapsedSeconds);
      }
    });
  }

  @override
  void togglePause() {
    _paused = !_paused;

    if (!_paused) {
      _controller.add(_elapsedSeconds);
    }
  }

  @override
  void close() {
    _subscription?.cancel();
    _controller.close();
  }
}
