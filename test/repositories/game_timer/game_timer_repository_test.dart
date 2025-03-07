import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:sudoku/repositories/game_timer_repository.dart';
import 'package:sudoku/services/game_timer_service.dart';
import 'package:talker/talker.dart';

import 'game_timer_repository_test.mocks.dart';

@GenerateMocks(
  [GameTimerService],
  customMocks: [
    MockSpec<Talker>(unsupportedMembers: {#configure}),
  ],
)
void main() {
  late GameTimerRepository repository;
  late MockGameTimerService gameTimerService;
  late MockTalker logger;

  setUp(() {
    logger = MockTalker();
    gameTimerService = MockGameTimerService();
    repository = GameTimerRepositoryImpl(
      logger: logger,
      gameTimerService: gameTimerService,
    );
  });

  group('when the method start is called', () {});

  group('when the method togglePause is called', () {});

  group('when the method close is called', () {});
}
