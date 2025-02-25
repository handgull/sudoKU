import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sudoku/models/enums/difficulty.dart';
import 'package:sudoku/models/sudoku_cell/sudoku_cell.dart';
import 'package:sudoku/models/sudoku_data/sudoku_data.dart';
import 'package:sudoku/repositories/mappers/sudoku_cell_mapper.dart';
import 'package:sudoku/repositories/mappers/sudoku_data_mapper.dart';
import 'package:sudoku/services/network/jto/sudoku_data/sudoku_data_jto.dart';

import '../../fixtures/jto/sudoku_data_jto_fixture_factory.dart';
import 'sudoku_data_mapper_test.mocks.dart';

@GenerateMocks([SudokuCellMapper])
void main() {
  late SudokuDataMapper mapper;
  late SudokuDataJTO dto;
  late SudokuData model;
  late MockSudokuCellMapper sudokuCellMapper;

  setUp(() {
    sudokuCellMapper = MockSudokuCellMapper();
    dto = SudokuDataJTOFixture.factory().makeSingle();

    model = SudokuData(
      board: dto.board
          .map(
            (subGrid) => subGrid
                .map(
                  (cellDTO) => SudokuCell(
                    value: cellDTO.value,
                    editable: cellDTO.editable,
                    invalidValue: cellDTO.invalidValue,
                    notes: cellDTO.notes,
                  ),
                )
                .toList(growable: false),
          )
          .toList(growable: false),
      solution: dto.solution,
      difficulty: Difficulty.values.firstWhere(
        (entry) => entry.value == dto.emptySquares,
        orElse: () => Difficulty.medium,
      ),
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
    for (var r = 0; r < dto.board.length; r++) {
      for (var c = 0; c < dto.board.length; c++) {
        verify(sudokuCellMapper.fromDTO(dto.board[r][c])).called(1);
      }
    }
  });

  test('mapping SudokuData to SudokuDataJTO', () {
    for (var r = 0; r < model.board.length; r++) {
      for (var c = 0; c < model.board.length; c++) {
        when(sudokuCellMapper.toDTO(model.board[r][c]))
            .thenReturn(dto.board[r][c]);
      }
    }

    expect(mapper.toDTO(model), equals(dto));
    for (var r = 0; r < model.board.length; r++) {
      for (var c = 0; c < model.board.length; c++) {
        verify(sudokuCellMapper.toDTO(model.board[r][c])).called(1);
      }
    }
  });
}
