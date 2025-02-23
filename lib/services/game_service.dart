import 'package:flutter/foundation.dart';
import 'package:sudoku/misc/sudoku_cell_operations.dart';
import 'package:sudoku/services/network/jto/sudoku_cell/sudoku_cell_jto.dart';
import 'package:sudoku/services/network/jto/sudoku_data/sudoku_data_jto.dart';
import 'package:sudoku_solver_generator/sudoku_solver_generator.dart';

abstract interface class GameService {
  SudokuDataJTO generate(int emptySquares);
  bool checkMove(
    int quadrant,
    int index,
    int value,
    List<List<SudokuCellJTO>> board,
  );
  List<List<SudokuCellJTO>> move(
    int quadrant,
    int index,
    SudokuCellJTO cellData,
    List<List<SudokuCellJTO>> board,
  );
  bool checkCompleted(List<List<SudokuCellJTO>> board);
  bool checkSolved(SudokuDataJTO data);
}

class GameServiceImpl implements GameService {
  const GameServiceImpl();

  @override
  SudokuDataJTO generate(int emptySquares) {
    final sudokuGenerator = SudokuGenerator(emptySquares: emptySquares);
    final board = sudokuGenerator.newSudoku;
    final solution = sudokuGenerator.newSudokuSolved;

    return SudokuDataJTO(
      board: board
          .map(
            (column) => column
                .map((cell) => SudokuCellJTO(value: cell, editable: cell == 0))
                .toList(growable: false),
          )
          .toList(growable: false),
      solution: solution,
      emptySquares: emptySquares,
    );
  }

  @override
  bool checkMove(
    int quadrant,
    int index,
    int value,
    List<List<SudokuCellJTO>> board,
  ) {
    if (quadrant < 0 || quadrant > 8 || index < 0 || index > 8) {
      return false;
    }

    final row = findCellRow(quadrant, index);
    final col = findCellCol(quadrant, index);

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
        final cellValue =
            board[quadrantStartRow + r][quadrantStartCol + c].value;
        if (r != row && c != col && cellValue == value) {
          return false;
        }
      }
    }

    return true;
  }

  @override
  List<List<SudokuCellJTO>> move(
    int quadrant,
    int index,
    SudokuCellJTO cellData,
    List<List<SudokuCellJTO>> board,
  ) {
    final row = findCellRow(quadrant, index);
    final col = findCellCol(quadrant, index);

    board[row][col] = cellData;
    return board;
  }

  @override
  bool checkCompleted(List<List<SudokuCellJTO>> board) =>
      board.every((quadrant) => quadrant.every((cell) => cell.value != 0));

  @override
  bool checkSolved(SudokuDataJTO data) {
    final expandedBoard = data.board
        .expand((quadrant) => quadrant.expand((cell) => [cell.value]))
        .toList(growable: false);

    final expandedSolution = data.solution
        .expand((quadrant) => quadrant.expand((cell) => [cell]))
        .toList(growable: false);

    return listEquals(expandedBoard, expandedSolution);
  }
}
