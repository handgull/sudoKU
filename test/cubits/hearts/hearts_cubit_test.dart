import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/cubits/hearts/hearts_cubit.dart';

void main() {
  late HeartsCubit cubit;

  setUp(() {
    cubit = HeartsCubit();
  });

  
  /// Testing the method [start]
  group('when the method start is called', () {
    blocTest<HeartsCubit, HeartsState>(
      'test that HeartsCubit emits HeartsState.active when start is called',
      setUp: () {
        //TODO: setup the environment
      },
      build: () => cubit,
      act: (cubit) {
        cubit.start();
      },
      expect: () => <HeartsState>[
        //TODO: define the emitted HeartsState states
      ],
      verify: (_) {
        //TODO: verify that methods are invoked properly
      },
    );
  });
  
  /// Testing the method [changeLife]
  group('when the method changeLife is called', () {
    blocTest<HeartsCubit, HeartsState>(
      'test that HeartsCubit emits HeartsState.active when changeLife is called',
      setUp: () {
        //TODO: setup the environment
      },
      build: () => cubit,
      act: (cubit) {
        cubit.changeLife();
      },
      expect: () => <HeartsState>[
        //TODO: define the emitted HeartsState states
      ],
      verify: (_) {
        //TODO: verify that methods are invoked properly
      },
    );
  });
  
}