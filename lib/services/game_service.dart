import 'package:sudoku/services/network/jto/sudoku_cell/sudoku_cell_jto.dart';
import 'package:sudoku/services/network/jto/sudoku_data/sudoku_data_jto.dart';
import 'package:sudoku_solver_generator/sudoku_solver_generator.dart';

abstract interface class GameService {
  SudokuDataJTO generate(int emptySquares);
  void checkMove();
  void checkGame();
}

class GameServiceImpl implements GameService {
  const GameServiceImpl();

  @override
  SudokuDataJTO generate(int emptySquares) {
    final sudokuGenerator = SudokuGenerator(emptySquares: emptySquares);
    final board = sudokuGenerator.newSudoku;
    final solution = sudokuGenerator.newSudokuSolved;

    return SudokuDataJTO(
      board: _mapCells(board),
      solution: _mapCells(solution),
      emptySquares: emptySquares,
    );
  }

  List<List<SudokuCellJTO>> _mapCells(List<List<int>> board) {
    return [0, 1, 2, 3, 4, 5, 6, 7, 8]
        .map((quadrantIndex) {
          return [0, 1, 2, 3, 4, 5, 6, 7, 8]
              .map((cellIndex) {
                final row = (cellIndex ~/ 3) + (quadrantIndex ~/ 3 * 3);
                final column = (cellIndex % 3) + (quadrantIndex % 3 * 3);

                final cellValue = board[row][column];

                return SudokuCellJTO(
                  value: cellValue,
                  editable: cellValue == 0,
                );
              })
              .toList(growable: false);
        })
        .toList(growable: false);
  }

  @override
  void checkMove() {}

  @override
  void checkGame() {}
}
