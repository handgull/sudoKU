import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/cubits/active_cell/active_cell_cubit.dart';

void main() {
  late ActiveCellCubit cubit;

  setUp(() {
    cubit = ActiveCellCubit();
  });

  
  /// Testing the method [setActive]
  group('when the method setActive is called', () {
    blocTest<ActiveCellCubit, ActiveCellState>(
      'test that ActiveCellCubit emits ActiveCellState.activating when setActive is called',
      setUp: () {
        //TODO: setup the environment
      },
      build: () => cubit,
      act: (cubit) {
        cubit.setActive();
      },
      expect: () => <ActiveCellState>[
        //TODO: define the emitted ActiveCellState states
      ],
      verify: (_) {
        //TODO: verify that methods are invoked properly
      },
    );
  });
  
}