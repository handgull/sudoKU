import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:sudoku/cubits/game_timer/game_timer_cubit.dart';
import 'package:sudoku/repositories/game_timer_repository.dart';

import 'game_timer_cubit_test.mocks.dart';

@GenerateMocks([GameTimerRepository])
void main() {
  late GameTimerCubit cubit;
  late MockGameTimerRepository repository;

  setUp(() {
    repository = MockGameTimerRepository();
    cubit = GameTimerCubit(gameTimerRepository: repository);
  });

  /// Testing the method [action]
  group('when the method action is called', () {
    blocTest<GameTimerCubit, GameTimerState>(
      'test that GameTimerCubit emits GameTimerState.initializing when action is called',
      setUp: () {
        //TODO: setup the environment
      },
      build: () => cubit,
      expect: () => <GameTimerState>[
        //TODO: define the emitted GameTimerState states
      ],
      verify: (_) {
        //TODO: verify that methods are invoked properly
      },
    );
  });
}
