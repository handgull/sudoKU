import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/models/enums/difficulty.dart';
import 'package:sudoku/models/sudoku_data/sudoku_data.dart';
import 'package:sudoku/repositories/mappers/sudoku_data.dart';
import 'package:sudoku/services/network/jto/sudoku_data/sudoku_data_jto.dart';

import '../../fixtures/jto/sudoku_data_jto_fixture_factory.dart';

void main() {
  late SudokuDataMapper mapper;
  late SudokuDataJTO dto;
  late SudokuData model;

  setUp(() {
    dto = SudokuDataJTOFixture.factory().makeSingle();

    model = SudokuData(
      board: dto.board,
      solution: dto.solution,
      difficulty: Difficulty.values.firstWhere(
        (entry) => entry.value == dto.emptySquares,
        orElse: () => Difficulty.medium,
      ),
    );
    mapper = const SudokuDataMapper();
  });

  test('mapping SudokuData object from SudokuDataJTO', () {
    expect(mapper.fromDTO(dto), equals(model));
  });

  test('mapping SudokuData to SudokuDataJTO', () {
    expect(mapper.toDTO(model), equals(dto));
  });
}
