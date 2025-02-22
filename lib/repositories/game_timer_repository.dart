import 'package:sudoku/services/game_timer_service.dart';

abstract interface class GameTimerRepository {
  Stream<int> get timer;
  bool get paused;
  void start();
  void togglePause();
  void close();
}

class GameTimerRepositoryImpl implements GameTimerRepository {
  const GameTimerRepositoryImpl({required this.gameTimerService});

  final GameTimerService gameTimerService;

  @override
  bool get paused => gameTimerService.paused;

  @override
  Stream<int> get timer => gameTimerService.timer;

  @override
  void start() {
    gameTimerService.start();
  }

  @override
  void togglePause() {
    gameTimerService.togglePause();
  }

  @override
  void close() {
    gameTimerService.close();
  }
}
