import 'package:pine/utils/dto_mapper.dart';
import 'package:sudoku/models/enums/difficulty.dart';
import 'package:sudoku/models/sudoku_cell/sudoku_cell.dart';
import 'package:sudoku/models/sudoku_data/sudoku_data.dart';
import 'package:sudoku/repositories/repository.dart';
import 'package:sudoku/services/game_service.dart';
import 'package:sudoku/services/network/jto/sudoku_cell/sudoku_cell_jto.dart';
import 'package:sudoku/services/network/jto/sudoku_data/sudoku_data_jto.dart';
import 'package:talker/talker.dart';

// I expect that with the current implementation,
// the program will never reach some of the error cases that i handled.
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

class GameRepositoryImpl extends Repository implements GameRepository {
  const GameRepositoryImpl({
    required this.logger,
    required this.gameService,
    required this.sudokuCellMapper,
    required this.sudokuDataMapper,
  });

  final Talker logger;
  final GameService gameService;
  final DTOMapper<SudokuCellJTO, SudokuCell> sudokuCellMapper;
  final DTOMapper<SudokuDataJTO, SudokuData> sudokuDataMapper;

  @override
  SudokuData generate(Difficulty difficulty) => safeCode(() {
        try {
          logger.info(
            '[GameRepository] Generating the board...',
          );

          final dto = gameService.generate(difficulty.value);

          final data = sudokuDataMapper.fromDTO(dto);
          logger.log(
            '[GameRepository] Successfully generated the board',
            pen: AnsiPen()..green(),
          );

          return data;
        } catch (error, stack) {
          logger.error(
            '[GameRepository] An error has occurred while generating: '
            'difficulty: ${difficulty.name}',
            error,
            stack,
          );

          rethrow;
        }
      });

  @override
  bool checkMove(
    int quadrant,
    int index,
    int value,
    List<List<SudokuCell>> board,
  ) =>
      safeCode(() {
        try {
          logger.info(
            '[GameRepository] Checking the move...',
          );
          final boardDTO = board
              .map(
                (subGrid) =>
                    subGrid.map(sudokuCellMapper.toDTO).toList(growable: false),
              )
              .toList(growable: false);

          final isValid =
              gameService.checkMove(quadrant, index, value, boardDTO);
          logger.log(
            '[GameRepository] Got the move validity',
            pen: AnsiPen()..green(),
          );
          return isValid;
        } catch (error, stack) {
          logger.error(
            '[GameRepository] An error has occurred while validating the move: '
            'quadrant: $quadrant, '
            'cell: $index, '
            'value: $value',
            error,
            stack,
          );

          rethrow;
        }
      });

  @override
  List<List<SudokuCell>> move(
    int quadrant,
    int index,
    SudokuCell cellData,
    List<List<SudokuCell>> board,
  ) =>
      safeCode(() {
        try {
          logger.info(
            '[GameRepository] Doing the move...',
          );

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
              .map(
                (row) =>
                    row.map(sudokuCellMapper.fromDTO).toList(growable: false),
              )
              .toList(growable: false);
          logger.log(
            '[GameRepository] Did the move successfully!',
            pen: AnsiPen()..green(),
          );

          return newBoard;
        } catch (error, stack) {
          logger.error(
            '[GameRepository] An error has occurred while doing the move: '
            'quadrant: $quadrant, '
            'cell: $index, '
            'value: ${cellData.value}',
            error,
            stack,
          );

          rethrow;
        }
      });

  @override
  bool checkCompleted(List<List<SudokuCell>> board) => safeCode(() {
        try {
          logger.info(
            '[GameRepository] Checking if the board is complete...',
          );

          final boardDTO = board
              .map(
                (subGrid) =>
                    subGrid.map(sudokuCellMapper.toDTO).toList(growable: false),
              )
              .toList(growable: false);

          final isCompleted = gameService.checkCompleted(boardDTO);

          logger.log(
            '[GameRepository] Checked if the board is complete: '
            '$isCompleted',
            pen: AnsiPen()..green(),
          );

          return isCompleted;
        } catch (error, stack) {
          logger.error(
            '[GameRepository] An error has occurred while checking the board',
            error,
            stack,
          );

          rethrow;
        }
      });

  @override
  bool checkSolved(SudokuData data) => safeCode(() {
        try {
          logger.info(
            '[GameRepository] Checking if the board is solved...',
          );
          final dto = sudokuDataMapper.toDTO(data);

          final isSolved = gameService.checkSolved(dto);
          logger.log(
            '[GameRepository] Checked if the board is solved: '
            '$isSolved',
            pen: AnsiPen()..green(),
          );

          return isSolved;
        } catch (error, stack) {
          logger.error(
            '[GameRepository] An error has occurred while checking '
            'if the board is solved',
            error,
            stack,
          );

          rethrow;
        }
      });

  @override
  List<List<SudokuCell>> addNote(
    int quadrant,
    int index,
    int value,
    List<List<SudokuCell>> board,
  ) =>
      safeCode(() {
        try {
          logger.info(
            '[GameRepository] Adding a note...',
          );
          final boardDTO = board
              .map(
                (subGrid) =>
                    subGrid.map(sudokuCellMapper.toDTO).toList(growable: false),
              )
              .toList(growable: false);

          final newBoardDTO =
              gameService.addNote(quadrant, index, value, boardDTO);

          final newBoard = newBoardDTO
              .map(
                (row) =>
                    row.map(sudokuCellMapper.fromDTO).toList(growable: false),
              )
              .toList(growable: false);
          logger.log(
            '[GameRepository] Added a note: '
            'quadrant: $quadrant, '
            'cell: $index, '
            'value: $value',
            pen: AnsiPen()..green(),
          );

          return newBoard;
        } catch (error, stack) {
          logger.error(
            '[GameRepository] An error has occurred while adding a note: '
            'quadrant: $quadrant, '
            'cell: $index, '
            'value: $value',
            error,
            stack,
          );

          rethrow;
        }
      });
}
