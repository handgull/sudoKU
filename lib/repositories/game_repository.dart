import 'package:pine/utils/dto_mapper.dart';
import 'package:sudoku/models/enums/difficulty.dart';
import 'package:sudoku/models/sudoku_data/sudoku_data.dart';
import 'package:sudoku/services/game_service.dart';
import 'package:sudoku/services/network/jto/sudoku_data/sudoku_data_jto.dart';

abstract interface class GameRepository {
  SudokuData generate(Difficulty difficulty);
  void checkMove();
  void checkGame();
}

class GameRepositoryImpl implements GameRepository {
  const GameRepositoryImpl({
    required this.gameService,
    required this.sudokuDataMapper,
  });

  final GameService gameService;
  final DTOMapper<SudokuDataJTO, SudokuData> sudokuDataMapper;

  @override
  SudokuData generate(Difficulty difficulty) {
    final dto = gameService.generate(difficulty.value);

    return sudokuDataMapper.fromDTO(dto);
  }

  @override
  void checkMove() {}

  @override
  void checkGame() {}
}
