import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:sudoku/repositories/game_repository.dart';
import 'package:sudoku/repositories/mappers/sudoku_data_mapper.dart';
import 'package:sudoku/services/game_service.dart';

import 'game_repository_test.mocks.dart';

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

  group('when the method generate is called', () {});

  group('when the method checkMove is called', () {});

  group('when the method checkGame is called', () {});
}
