import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sudoku/repositories/game_repository.dart';
import 'package:sudoku/repositories/mappers/sudoku_data.dart';
import 'package:sudoku/services/game_service.dart';

import 'game_repository_test.mocks.dart';

/// Test case for the class GameRepositoryImpl
@GenerateMocks([SudokuDataMapper, GameService])
void main() {
  late GameRepository repository;
  late MockGameService gameService;
  late MockSudokuDataMapper sudokuDataMapper;

  setUp(() {
    sudokuDataMapper = MockSudokuDataMapper();
    gameService = MockGameService();
    repository = GameRepositoryImpl(
      gameService: gameService,
      sudokuDataMapper: sudokuDataMapper,
    );
  });

  /// Testing the method [generate]
  group('when the method generate is called', () {});

  /// Testing the method [checkMove]
  group('when the method checkMove is called', () {});

  /// Testing the method [checkGame]
  group('when the method checkGame is called', () {});
}
