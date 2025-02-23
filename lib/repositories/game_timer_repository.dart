import 'package:sudoku/services/game_timer_service.dart';

abstract interface class GameTimerRepository {
  Stream<int> get timer;
  bool get paused;
  void start([int initSeconds = 0]);
  void togglePause();
  Future<void> close();
}

class GameTimerRepositoryImpl implements GameTimerRepository {
  const GameTimerRepositoryImpl({required this.gameTimerService});

  final GameTimerService gameTimerService;

  @override
  bool get paused => gameTimerService.paused;

  @override
  Stream<int> get timer => gameTimerService.timer;

  @override
  void start([int initSeconds = 0]) {
    gameTimerService.start(initSeconds);
  }

  @override
  void togglePause() {
    gameTimerService.togglePause();
  }

  @override
  Future<void> close() async {
    await gameTimerService.close();
  }
}
