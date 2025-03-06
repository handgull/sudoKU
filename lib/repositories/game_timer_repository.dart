import 'package:sudoku/repositories/repository.dart';
import 'package:sudoku/services/game_timer_service.dart';
import 'package:talker/talker.dart';

// I expect that with the current implementation,
// the program will never reach some of the error cases that i handled.
abstract interface class GameTimerRepository {
  Stream<int> get timer;
  bool get paused;
  void start([int initSeconds = 0]);
  void togglePause();
  Future<void> close();
}

class GameTimerRepositoryImpl extends Repository
    implements GameTimerRepository {
  const GameTimerRepositoryImpl({
    required this.logger,
    required this.gameTimerService,
  });

  final Talker logger;
  final GameTimerService gameTimerService;

  @override
  bool get paused => gameTimerService.paused;

  @override
  Stream<int> get timer => gameTimerService.timer;

  @override
  void start([int initSeconds = 0]) => safeCode(
        () {
          try {
            logger.info(
              '[GameTimerRepository] Starting the timer...',
            );

            gameTimerService.start(initSeconds);

            logger.log(
              '[GameTimerRepository] The timer now is started',
              pen: AnsiPen()..green(),
            );
          } catch (error, stack) {
            logger.error(
              '[GameTimerRepository] An error has occurred while starting: '
              'initSeconds: $initSeconds',
              error,
              stack,
            );

            rethrow;
          }
        },
      );

  @override
  void togglePause() => safeCode(
        () {
          try {
            logger.info(
              '[GameTimerRepository] Toggling the timer...',
            );

            gameTimerService.togglePause();

            logger.log(
              '[GameTimerRepository] Toggled the timer: '
              'paused: ${gameTimerService.paused}',
              pen: AnsiPen()..green(),
            );
          } catch (error, stack) {
            logger.error(
              '[GameTimerRepository] An error has occurred while toggling: '
              'paused: ${gameTimerService.paused}',
              error,
              stack,
            );

            rethrow;
          }
        },
      );

  @override
  Future<void> close() => safeCode(
        () async => gameTimerService.close(),
      );
}
