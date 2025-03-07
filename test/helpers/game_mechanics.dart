// Some methods are repeated and not imported from the source
// tests should not dependend on the source code

import 'package:sudoku/services/network/jto/sudoku_cell/sudoku_cell_jto.dart';
import 'package:sudoku_solver_generator/sudoku_solver_generator.dart';

int tfindCellRow(int quadrant, int index) => (quadrant ~/ 3) * 3 + (index ~/ 3);

int tfindCellCol(int quadrant, int index) => (quadrant % 3) * 3 + (index % 3);

int tfindCellQuadrant(int row, int col) => (row ~/ 3) * 3 + (col ~/ 3);

int tfindCellIndex(int row, int col) => (row % 3) * 3 + (col % 3);

bool tcheckMove(
  int quadrant,
  int index,
  int value,
  List<List<SudokuCellJTO>> board,
) {
  if (quadrant < 0 || quadrant > 8 || index < 0 || index > 8 || value > 9) {
    throw InvalidSudokuConfigurationException();
  } else if (value == 0) {
    return true;
  }

  final row = tfindCellRow(quadrant, index);
  final col = tfindCellCol(quadrant, index);

  for (var c = 0; c < 9; c++) {
    final cellValue = board[row][c].value;
    if (c != col && cellValue == value) {
      return false;
    }
  }

  for (var r = 0; r < 9; r++) {
    final cellValue = board[r][col].value;
    if (r != row && cellValue == value) {
      return false;
    }
  }

  final quadrantStartRow = (row ~/ 3) * 3;
  final quadrantStartCol = (col ~/ 3) * 3;

  for (var r = 0; r < 3; r++) {
    for (var c = 0; c < 3; c++) {
      final cellValue = board[quadrantStartRow + r][quadrantStartCol + c].value;
      if (r != row && c != col && cellValue == value) {
        return false;
      }
    }
  }

  return true;
}
