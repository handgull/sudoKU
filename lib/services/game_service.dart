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
      board: board,
      solution: solution,
      emptySquares: emptySquares,
    );
  }

  @override
  void checkMove() {}

  @override
  void checkGame() {}
}
