import 'package:data_fixture_dart/data_fixture_dart.dart';
import 'package:sudoku/models/enums/difficulty.dart';
import 'package:sudoku/services/network/jto/sudoku_data/sudoku_data_jto.dart';

import 'sudoku_cell_jto_fixture_factory.dart';

extension SudokuDataJTOFixture on SudokuDataJTO {
  static SudokuDataJTOFixtureFactory factory() => SudokuDataJTOFixtureFactory();
}

class SudokuDataJTOFixtureFactory extends JsonFixtureFactory<SudokuDataJTO> {
  @override
  FixtureDefinition<SudokuDataJTO> definition() => define(
        (faker) => SudokuDataJTO(
          board: faker.randomGenerator
              .amount(
                (_) => SudokuCellJTOFixture.factory()
                    .makeMany(9, growableList: false),
                9,
                min: 9,
              )
              .toList(growable: false),
          solution: faker.randomGenerator
              .amount(
                (_) => faker.randomGenerator
                    .amount(
                      (_) => faker.randomGenerator.integer(9, min: 1),
                      9,
                      min: 9,
                    )
                    .toList(growable: false),
                9,
                min: 9,
              )
              .toList(growable: false),
          emptySquares: faker.randomGenerator.element(
            Difficulty.values
                .map((difficulty) => difficulty.value)
                .toList(growable: false),
          ),
        ),
      );

  @override
  JsonFixtureDefinition<SudokuDataJTO> jsonDefinition() => defineJson(
        (object) => {
          'board': object.board,
          'solution': object.solution,
          'emptySquares': object.emptySquares,
        },
      );
}
