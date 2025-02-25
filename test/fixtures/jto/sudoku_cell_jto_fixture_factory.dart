import 'package:data_fixture_dart/data_fixture_dart.dart';
import 'package:sudoku/services/network/jto/sudoku_cell/sudoku_cell_jto.dart';

extension SudokuCellJTOFixture on SudokuCellJTO {
  static SudokuCellJTOFixtureFactory factory() => SudokuCellJTOFixtureFactory();
}

class SudokuCellJTOFixtureFactory extends JsonFixtureFactory<SudokuCellJTO> {
  @override
  FixtureDefinition<SudokuCellJTO> definition() => define(
        (faker) => SudokuCellJTO(
          value: faker.randomGenerator.integer(9),
          editable: faker.randomGenerator.boolean(),
          invalidValue: faker.randomGenerator.boolean(),
          notes: faker.randomGenerator
              .amount((_) => faker.randomGenerator.integer(9, min: 1), 9)
              .toSet(),
        ),
      );

  FixtureDefinition<SudokuCellJTO> withoutNotes() => redefine(
        (_) => SudokuCellJTO(
          value: faker.randomGenerator.integer(9),
          editable: faker.randomGenerator.boolean(),
          invalidValue: faker.randomGenerator.boolean(),
          notes: {},
        ),
      );

  @override
  JsonFixtureDefinition<SudokuCellJTO> jsonDefinition() => defineJson(
        (object) => {
          'value': object.value,
          'editable': object.editable,
          'invalidValue': object.invalidValue,
          'notes': object.notes,
        },
      );
}
