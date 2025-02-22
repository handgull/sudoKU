import 'package:data_fixture_dart/data_fixture_dart.dart';
import 'package:sudoku/models/sudoku_cell/sudoku_cell.dart';

extension SudokuCellFixture on SudokuCell {
  static SudokuCellFixtureFactory factory() => SudokuCellFixtureFactory();
}

class SudokuCellFixtureFactory extends FixtureFactory<SudokuCell> {
  @override
  FixtureDefinition<SudokuCell> definition() => define(
    (faker) => SudokuCell(
      value: faker.randomGenerator.integer(9, min: 1),
      editable: faker.randomGenerator.boolean(),
      invalidValue: faker.randomGenerator.boolean(),
      notes:
          faker.randomGenerator
              .amount((_) => faker.randomGenerator.integer(9, min: 1), 9)
              .toSet(),
    ),
  );
}
