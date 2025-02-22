import 'package:data_fixture_dart/data_fixture_dart.dart';
import 'package:sudoku/services/network/jto/sudoku_data/sudoku_data_jto.dart';

extension SudokuDataJTOFixture on SudokuDataJTO {
  static SudokuDataJTOFixtureFactory factory() => SudokuDataJTOFixtureFactory();
}

class SudokuDataJTOFixtureFactory extends JsonFixtureFactory<SudokuDataJTO> {
  @override
  FixtureDefinition<SudokuDataJTO> definition() => define(
    (faker) => SudokuDataJTO(
      board: faker.randomGenerator
          .amount<List<int>>(
            (_) => faker.randomGenerator
                .amount<int>(
                  (_) => faker.randomGenerator.integer(9, min: 1),
                  9,
                  min: 9,
                )
                .toList(growable: false),
            9,
            min: 9,
          )
          .toList(growable: false),
      solution: faker.randomGenerator
          .amount<List<int>>(
            (_) => faker.randomGenerator
                .amount<int>(
                  (_) => faker.randomGenerator.integer(9, min: 1),
                  9,
                  min: 9,
                )
                .toList(growable: false),
            9,
            min: 9,
          )
          .toList(growable: false),
      emptySquares: faker.randomGenerator.integer(100),
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
