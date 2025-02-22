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
  bool checkMove(
    int quadrant,
    int index,
    int value,
    List<List<SudokuCellJTO>> board,
  ) {
    if (quadrant < 0 || quadrant > 8 || index < 0 || index > 8) {
      return false;
    }

    final row = (quadrant ~/ 3) * 3 + (index ~/ 3);
    final col = (quadrant % 3) * 3 + (index % 3);

    for (var c = 0; c < 9; c++) {
      if (c != col && board[row][c].value == value) {
        return false;
      }
    }

    for (var r = 0; r < 9; r++) {
      if (r != row && board[r][col].value == value) {
        return false;
      }
    }

    final quadrantStartRow = (row ~/ 3) * 3;
    final quadrantStartCol = (col ~/ 3) * 3;

    for (var r = 0; r < 3; r++) {
      for (var c = 0; c < 3; c++) {
        final checkRow = quadrantStartRow + r;
        final checkCol = quadrantStartCol + c;

        final quadrantIndex = (checkRow ~/ 3) * 3 + (checkCol ~/ 3);
        final cellIndex = (checkRow % 3) * 3 + (checkCol % 3);

        if ((checkRow != row || checkCol != col) &&
            board[quadrantIndex][cellIndex].value == value) {
          return false;
        }
      }
    }

    return true;
  }

  @override
  void checkGame() {}
}
