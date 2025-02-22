import 'package:pine/utils/dto_mapper.dart';
import 'package:sudoku/models/enums/difficulty.dart';
import 'package:sudoku/models/sudoku_cell/sudoku_cell.dart';
import 'package:sudoku/models/sudoku_data/sudoku_data.dart';
import 'package:sudoku/services/game_service.dart';
import 'package:sudoku/services/network/jto/sudoku_cell/sudoku_cell_jto.dart';
import 'package:sudoku/services/network/jto/sudoku_data/sudoku_data_jto.dart';

abstract interface class GameRepository {
  SudokuData generate(Difficulty difficulty);
  void checkMove(
    int quadrant,
    int index,
    int value,
    List<List<SudokuCell>> board,
  );
  void checkGame();
}

class GameRepositoryImpl implements GameRepository {
  const GameRepositoryImpl({
    required this.gameService,
    required this.sudokuCellMapper,
    required this.sudokuDataMapper,
  });

  final GameService gameService;
  final DTOMapper<SudokuCellJTO, SudokuCell> sudokuCellMapper;
  final DTOMapper<SudokuDataJTO, SudokuData> sudokuDataMapper;

  @override
  SudokuData generate(Difficulty difficulty) {
    final dto = gameService.generate(difficulty.value);

    return sudokuDataMapper.fromDTO(dto);
  }

  @override
  bool checkMove(
    int quadrant,
    int index,
    int value,
    List<List<SudokuCell>> board,
  ) {
    final boardDTO = board
        .map(
          (subGrid) =>
              subGrid.map(sudokuCellMapper.toDTO).toList(growable: false),
        )
        .toList(growable: false);
    return gameService.checkMove(quadrant, index, value, boardDTO);
  }

  @override
  void checkGame() {}
}
