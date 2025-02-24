import 'package:pine/pine.dart';
import 'package:sudoku/models/enums/difficulty.dart';
import 'package:sudoku/models/sudoku_cell/sudoku_cell.dart';
import 'package:sudoku/models/sudoku_data/sudoku_data.dart';
import 'package:sudoku/services/network/jto/sudoku_cell/sudoku_cell_jto.dart';
import 'package:sudoku/services/network/jto/sudoku_data/sudoku_data_jto.dart';

// with the mapper pattern if the source of data changes
// the internal business logic is more protected from breaking changes
class SudokuDataMapper extends DTOMapper<SudokuDataJTO, SudokuData> {
  const SudokuDataMapper({required this.sudokuCellMapper});

  final DTOMapper<SudokuCellJTO, SudokuCell> sudokuCellMapper;

  @override
  SudokuData fromDTO(SudokuDataJTO dto) => SudokuData(
    board: dto.board
        .map(
          (subGrid) =>
              subGrid.map(sudokuCellMapper.fromDTO).toList(growable: false),
        )
        .toList(growable: false),
    solution: dto.solution,
    difficulty: Difficulty.values.firstWhere(
      (entry) => entry.value == dto.emptySquares,
      orElse: () => Difficulty.medium,
    ),
  );

  @override
  SudokuDataJTO toDTO(SudokuData model) => SudokuDataJTO(
    board: model.board
        .map(
          (subGrid) =>
              subGrid.map(sudokuCellMapper.toDTO).toList(growable: false),
        )
        .toList(growable: false),
    solution: model.solution,
    emptySquares: model.difficulty.value,
  );
}
