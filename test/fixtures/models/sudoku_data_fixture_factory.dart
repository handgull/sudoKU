import 'package:data_fixture_dart/data_fixture_dart.dart';
import 'package:sudoku/models/enums/difficulty.dart';
import 'package:sudoku/models/sudoku_data/sudoku_data.dart';

extension SudokuDataFixture on SudokuData {
  static SudokuDataFixtureFactory factory() => SudokuDataFixtureFactory();
}

class SudokuDataFixtureFactory extends FixtureFactory<SudokuData> {
  @override
  FixtureDefinition<SudokuData> definition() => define(
    (faker) => SudokuData(
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
      difficulty: faker.randomGenerator.element(Difficulty.values),
    ),
  );
}
