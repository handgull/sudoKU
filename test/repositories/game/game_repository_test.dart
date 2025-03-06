import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sudoku/errors/repository_exception.dart';
import 'package:sudoku/models/enums/difficulty.dart';
import 'package:sudoku/models/sudoku_data/sudoku_data.dart';
import 'package:sudoku/repositories/game_repository.dart';
import 'package:sudoku/repositories/mappers/sudoku_cell_mapper.dart';
import 'package:sudoku/repositories/mappers/sudoku_data_mapper.dart';
import 'package:sudoku/services/game_service.dart';
import 'package:sudoku/services/network/jto/sudoku_cell/sudoku_cell_jto.dart';
import 'package:sudoku/services/network/jto/sudoku_data/sudoku_data_jto.dart';
import 'package:talker/talker.dart';

import '../../fixtures/models/sudoku_data_fixture_factory.dart';
import 'game_repository_test.mocks.dart';

@GenerateMocks(
  [SudokuCellMapper, SudokuDataMapper, GameService],
  customMocks: [
    MockSpec<Talker>(unsupportedMembers: {#configure}),
  ],
)
void main() {
  late GameRepository repository;
  late MockGameService gameService;
  late MockSudokuCellMapper sudokuCellMapper;
  late MockSudokuDataMapper sudokuDataMapper;
  late MockTalker logger;
  late SudokuData sudokuData;
  late SudokuDataJTO sudokuDataJTO;

  setUp(() {
    sudokuCellMapper = MockSudokuCellMapper();
    sudokuDataMapper = MockSudokuDataMapper();
    gameService = MockGameService();
    logger = MockTalker();
    repository = GameRepositoryImpl(
      logger: logger,
      gameService: gameService,
      sudokuCellMapper: sudokuCellMapper,
      sudokuDataMapper: sudokuDataMapper,
    );
    sudokuData = SudokuDataFixtureFactory().makeSingle();
    sudokuDataJTO = SudokuDataJTO(
      board: sudokuData.board
          .map(
            (quadrant) => quadrant
                .map(
                  (cell) => SudokuCellJTO(
                    value: cell.value,
                  ),
                )
                .toList(growable: false),
          )
          .toList(growable: false),
      solution: sudokuData.solution,
      emptySquares: sudokuData.difficulty.value,
    );
  });

  group('[PaymentRepository] Testing the generate method', () {
    late Difficulty difficulty;

    setUp(() {
      difficulty = Difficulty.values.firstWhere(
        (entry) => entry.value == sudokuDataJTO.emptySquares,
        orElse: () => Difficulty.medium,
      );
    });

    test('The data should be generated successfully', () async {
      when(gameService.generate(sudokuDataJTO.emptySquares)).thenAnswer(
        (_) => sudokuDataJTO,
      );
      when(sudokuDataMapper.fromDTO(sudokuDataJTO)).thenReturn(sudokuData);

      final result = repository.generate(difficulty);
      expect(result, equals(sudokuData));

      verify(gameService.generate(sudokuDataJTO.emptySquares)).called(1);
      verify(sudokuDataMapper.fromDTO(sudokuDataJTO)).called(1);
    });

    test('Testing the generation with a service error', () async {
      when(gameService.generate(sudokuDataJTO.emptySquares)).thenThrow(Error());

      try {
        repository.generate(difficulty);
        expect(true, isFalse, reason: 'Unexpected return from function.');
      } on Exception catch (error) {
        expect(error, isInstanceOf<RepositoryException>());
      }

      verify(gameService.generate(sudokuDataJTO.emptySquares)).called(1);
      verifyNever(sudokuDataMapper.fromDTO(sudokuDataJTO));
    });
  });
}
