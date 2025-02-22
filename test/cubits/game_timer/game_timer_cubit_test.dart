import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/cubits/game_timer/game_timer_cubit.dart';

void main() {
  late GameTimerCubit cubit;

  setUp(() {
    cubit = GameTimerCubit();
  });

  /// Testing the method [action]
  group('when the method action is called', () {
    blocTest<GameTimerCubit, GameTimerState>(
      'test that GameTimerCubit emits GameTimerState.initializing when action is called',
      setUp: () {
        //TODO: setup the environment
      },
      build: () => cubit,
      act: (cubit) {
        cubit.action();
      },
      expect:
          () => <GameTimerState>[
            //TODO: define the emitted GameTimerState states
          ],
      verify: (_) {
        //TODO: verify that methods are invoked properly
      },
    );
  });
}
