import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/cubits/hearts/hearts_cubit.dart';

import '../../helpers/hydrated_blocs.dart';

void main() {
  late HeartsCubit cubit;

  setUp(() {
    initHydratedStorage();
    cubit = HeartsCubit();
  });

  group('[HeartsCubit] when the method changeLife is called', () {
    blocTest<HeartsCubit, HeartsState>(
      'test that cubit emits HeartsState.active when changeLife is called',
      setUp: () {
        // I do not need to mock nothing
      },
      build: () => cubit,
      act: (cubit) {
        cubit.changeLife(-1);
      },
      expect: () => <HeartsState>[
        const HeartsState.changingHearts(3),
        const HeartsState.active(2),
      ],
      verify: (_) {
        // I do not need to call nothing to set the active cell
        // (this can change if will not be used HydratedCubit for persistance)
      },
    );
  });
}
