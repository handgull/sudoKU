import 'package:pine/pine.dart';
import 'package:sudoku/models/enums/difficulty.dart';
import 'package:sudoku/models/sudoku_data/sudoku_data.dart';
import 'package:sudoku/services/network/jto/sudoku_data/sudoku_data_jto.dart';

class SudokuDataMapper extends DTOMapper<SudokuDataJTO, SudokuData> {
  const SudokuDataMapper();

  @override
  SudokuData fromDTO(SudokuDataJTO dto) => SudokuData(
    board: dto.board,
    solution: dto.solution,
    difficulty: Difficulty.values.firstWhere(
      (entry) => entry.value == dto.emptySquares,
      orElse: () => Difficulty.medium,
    ),
  );

  @override
  SudokuDataJTO toDTO(SudokuData model) => SudokuDataJTO(
    board: model.board,
    solution: model.solution,
    emptySquares: model.difficulty.value,
  );
}
