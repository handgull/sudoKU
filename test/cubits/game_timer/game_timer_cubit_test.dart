import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sudoku/cubits/game_timer/game_timer_cubit.dart';
import 'package:sudoku/repositories/game_timer_repository.dart';

import '../../helpers/hydrated_blocs.dart';
import 'game_timer_cubit_test.mocks.dart';

// TODO add some more tests
@GenerateMocks([GameTimerRepository])
void main() {
  late MockGameTimerRepository repository;

  setUp(() {
    initHydratedStorage();
    repository = MockGameTimerRepository();
  });

  /// Testing the method [action]
  group(
    'when the method action is called',
    () {
      blocTest<GameTimerCubit, GameTimerState>(
        'test that cubit emits GameTimerState.ticked when start is called',
        setUp: () {
          when(repository.timer).thenAnswer((_) async* {
            yield 1;
            yield 2;
            yield 3;
          });
        },
        build: () => GameTimerCubit(gameTimerRepository: repository),
        expect: () => <GameTimerState>[
          const GameTimerState.ticked(1),
          const GameTimerState.ticked(2),
          const GameTimerState.ticked(3),
        ],
        verify: (_) {
          verify(repository.timer).called(1);
        },
      );
    },
  );
}
