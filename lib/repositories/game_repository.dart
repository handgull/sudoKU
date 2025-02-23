import 'package:pine/utils/dto_mapper.dart';
import 'package:sudoku/models/enums/difficulty.dart';
import 'package:sudoku/models/sudoku_cell/sudoku_cell.dart';
import 'package:sudoku/models/sudoku_data/sudoku_data.dart';
import 'package:sudoku/services/game_service.dart';
import 'package:sudoku/services/network/jto/sudoku_cell/sudoku_cell_jto.dart';
import 'package:sudoku/services/network/jto/sudoku_data/sudoku_data_jto.dart';

abstract interface class GameRepository {
  SudokuData generate(Difficulty difficulty);
  bool checkMove(
    int quadrant,
    int index,
    int value,
    List<List<SudokuCell>> board,
  );
  List<List<SudokuCell>> move(
    int quadrant,
    int index,
    SudokuCell cellData,
    List<List<SudokuCell>> board,
  );
  bool checkCompleted(List<List<SudokuCell>> board);
  bool checkSolved(SudokuData data);
  List<List<SudokuCell>> addNote(
    int quadrant,
    int index,
    int value,
    List<List<SudokuCell>> board,
  );
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
  List<List<SudokuCell>> move(
    int quadrant,
    int index,
    SudokuCell cellData,
    List<List<SudokuCell>> board,
  ) {
    final boardDTO = board
        .map(
          (subGrid) =>
              subGrid.map(sudokuCellMapper.toDTO).toList(growable: false),
        )
        .toList(growable: false);

    final newBoardDTO = gameService.move(
      quadrant,
      index,
      sudokuCellMapper.toDTO(cellData),
      boardDTO,
    );

    final newBoard = newBoardDTO
        .map((row) => row.map(sudokuCellMapper.fromDTO).toList(growable: false))
        .toList(growable: false);

    return newBoard;
  }

  @override
  bool checkCompleted(List<List<SudokuCell>> board) {
    final boardDTO = board
        .map(
          (subGrid) =>
              subGrid.map(sudokuCellMapper.toDTO).toList(growable: false),
        )
        .toList(growable: false);

    return gameService.checkCompleted(boardDTO);
  }

  @override
  bool checkSolved(SudokuData data) {
    final dto = sudokuDataMapper.toDTO(data);

    return gameService.checkSolved(dto);
  }

  @override
  List<List<SudokuCell>> addNote(
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

    final newBoardDTO = gameService.addNote(quadrant, index, value, boardDTO);

    final newBoard = newBoardDTO
        .map((row) => row.map(sudokuCellMapper.fromDTO).toList(growable: false))
        .toList(growable: false);

    return newBoard;
  }
}
