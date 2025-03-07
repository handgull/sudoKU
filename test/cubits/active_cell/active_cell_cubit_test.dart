import 'package:bloc_test/bloc_test.dart';
import 'package:data_fixture_dart/data_fixture_dart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/cubits/active_cell/active_cell_cubit.dart';

void main() {
  late ActiveCellCubit cubit;
  late int quadrant;
  late int index;

  setUp(() {
    cubit = ActiveCellCubit();
    quadrant = faker.randomGenerator.integer(8);
    index = faker.randomGenerator.integer(8);
  });

  /// Testing the method [setActive]
  group('[ActiveCellCubit] when the method setActive is called', () {
    blocTest<ActiveCellCubit, ActiveCellState>(
      'test that cubit emits ActiveCellState.active when setActive is called',
      setUp: () {
        // I do not need to mock nothing
      },
      build: () => cubit,
      act: (cubit) {
        cubit.setActive(quadrant, index);
      },
      expect: () => <ActiveCellState>[
        const ActiveCellState.activating(),
        ActiveCellState.active(quadrant, index),
      ],
      verify: (_) {
        // I do not need to call nothing to set the active cell
        // (this can change if will not be used HydratedCubit for persistance)
      },
    );
  });
}
