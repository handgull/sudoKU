import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sudoku/blocs/game/game_bloc.dart';
import 'package:sudoku/errors/repository_exception.dart';
import 'package:sudoku/models/sudoku_data/sudoku_data.dart';
import 'package:sudoku/repositories/game_repository.dart';
import 'package:sudoku/repositories/game_timer_repository.dart';

import '../../fixtures/models/sudoku_data_fixture_factory.dart';
import '../../helpers/hydrated_blocs.dart';
import 'game_bloc_test.mocks.dart';

// TODO add some more tests
@GenerateMocks([GameRepository, GameTimerRepository])
void main() {
  late GameBloc bloc;
  late MockGameRepository gameRepository;
  late MockGameTimerRepository gameTimerRepository;
  late SudokuData sudokuData;

  setUp(() {
    initHydratedStorage();
    gameRepository = MockGameRepository();
    gameTimerRepository = MockGameTimerRepository();
    bloc = GameBloc(
      gameRepository: gameRepository,
      gameTimerRepository: gameTimerRepository,
    );
    sudokuData = SudokuDataFixtureFactory().makeSingle();
  });

  group('[GameBloc] when the event StartGameEvent is added to the BLoC', () {
    blocTest<GameBloc, GameState>(
      'test that bloc emits GameState.active when start is called',
      setUp: () {
        when(gameRepository.generate(any)).thenAnswer((_) => sudokuData);
      },
      build: () => bloc,
      act: (bloc) {
        bloc.start();
      },
      expect: () => <GameState>[
        const GameState.starting(),
        GameState.running(sudokuData),
      ],
      verify: (_) {
        verify(gameRepository.generate(any)).called(1);
      },
    );

    blocTest<GameBloc, GameState>(
      'test that bloc emits AccountState.errorRunning on game repo error',
      setUp: () {
        when(gameRepository.generate(any)).thenThrow(RepositoryException(''));
      },
      build: () => bloc,
      act: (bloc) {
        bloc.start();
      },
      expect: () => <GameState>[
        const GameState.starting(),
        const GameState.errorStarting(),
      ],
      verify: (_) {
        verify(gameRepository.generate(any)).called(1);
      },
    );
  });
}
