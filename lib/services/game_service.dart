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
  List<List<SudokuCellJTO>> addNote(
    int quadrant,
    int index,
    int value,
    List<List<SudokuCellJTO>> board,
  );
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
    final row = findCellRow(quadrant, index);
    final col = findCellCol(quadrant, index);
    final rawBoard = board
        .map(
          (quadrant) =>
              quadrant.map((cell) => cell.value).toList(growable: false),
        )
        .toList(growable: false);
    rawBoard[row][col] = value;

    // This utility checks all the game logic
    // open the service tests to check my implementation
    return SudokuUtilities.isValidConfiguration(rawBoard);
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

  @override
  List<List<SudokuCellJTO>> addNote(
    int quadrant,
    int index,
    int value,
    List<List<SudokuCellJTO>> board,
  ) {
    final row = findCellRow(quadrant, index);
    final col = findCellCol(quadrant, index);

    board[row][col] = board[row][col].copyWith(
      notes: {...board[row][col].notes, value},
    );

    return board;
  }
}
