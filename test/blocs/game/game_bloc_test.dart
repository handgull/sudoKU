import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:sudoku/blocs/game/game_bloc.dart';
import 'package:sudoku/repositories/game_repository.dart';
import 'package:sudoku/repositories/game_timer_repository.dart';

import 'game_bloc_test.mocks.dart';

@GenerateMocks([GameRepository, GameTimerRepository])
void main() {
  late GameBloc bloc;
  late MockGameRepository gameRepository;
  late MockGameTimerRepository gameTimerRepository;

  setUp(() {
    gameRepository = MockGameRepository();
    gameTimerRepository = MockGameTimerRepository();
    bloc = GameBloc(
      gameRepository: gameRepository,
      gameTimerRepository: gameTimerRepository,
    );
  });

  /// Testing the event [StartGameEvent]
  group('when the event StartGameEvent is added to the BLoC', () {
    blocTest<GameBloc, GameState>(
      'test that GameBloc emits GameState.starting when start is called',
      setUp: () {
        //TODO: setup the environment
      },
      build: () => bloc,
      act: (bloc) {
        bloc.start();
      },
      expect: () => <GameState>[
        //TODO: define the emitted GameState states
      ],
      verify: (_) {
        //TODO: verify that methods are invoked properly
      },
    );
  });
}
