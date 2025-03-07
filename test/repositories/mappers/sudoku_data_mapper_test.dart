import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sudoku/models/sudoku_data/sudoku_data.dart';
import 'package:sudoku/repositories/mappers/sudoku_cell_mapper.dart';
import 'package:sudoku/repositories/mappers/sudoku_data_mapper.dart';
import 'package:sudoku/services/network/jto/sudoku_cell/sudoku_cell_jto.dart';
import 'package:sudoku/services/network/jto/sudoku_data/sudoku_data_jto.dart';

import '../../fixtures/models/sudoku_data_fixture_factory.dart';
import 'sudoku_data_mapper_test.mocks.dart';

@GenerateMocks([SudokuCellMapper])
void main() {
  late SudokuDataMapper mapper;
  late SudokuDataJTO dto;
  late SudokuData model;
  late MockSudokuCellMapper sudokuCellMapper;

  setUp(() {
    sudokuCellMapper = MockSudokuCellMapper();
    model = SudokuDataFixture.factory().makeSingle();

    dto = SudokuDataJTO(
      board: model.board
          .map(
            (subGrid) => subGrid
                .map(
                  (cell) => SudokuCellJTO(
                    value: cell.value,
                    editable: cell.editable,
                    invalidValue: cell.invalidValue,
                    notes: cell.notes,
                  ),
                )
                .toList(growable: false),
          )
          .toList(growable: false),
      solution: model.solution,
      emptySquares: model.difficulty.value,
    );
    mapper = SudokuDataMapper(sudokuCellMapper: sudokuCellMapper);
  });

  test('mapping SudokuData object from SudokuDataJTO', () {
    for (var r = 0; r < dto.board.length; r++) {
      for (var c = 0; c < dto.board.length; c++) {
        when(sudokuCellMapper.fromDTO(dto.board[r][c]))
            .thenReturn(model.board[r][c]);
      }
    }

    expect(mapper.fromDTO(dto), equals(model));
  });

  test('mapping SudokuData to SudokuDataJTO', () {
    for (var r = 0; r < model.board.length; r++) {
      for (var c = 0; c < model.board.length; c++) {
        when(sudokuCellMapper.toDTO(model.board[r][c]))
            .thenReturn(dto.board[r][c]);
      }
    }

    expect(mapper.toDTO(model), equals(dto));
  });
}
