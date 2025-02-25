import 'package:data_fixture_dart/data_fixture_dart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/services/game_service.dart';
import 'package:sudoku/services/network/jto/sudoku_cell/sudoku_cell_jto.dart';
import 'package:sudoku/services/network/jto/sudoku_data/sudoku_data_jto.dart';

import '../../fixtures/jto/sudoku_cell_jto_fixture_factory.dart';
import '../../misc/sudoku_cell_operations.dart';

void main() {
  late GameService service;
  late int emptySquares;
  late List<List<SudokuCellJTO>> randomBoard;

  setUp(() {
    service = const GameServiceImpl();
    emptySquares = faker.randomGenerator.integer(54, min: 1);
    randomBoard = faker.randomGenerator
        .amount(
          (_) =>
              SudokuCellJTOFixture.factory().makeMany(9, growableList: false),
          9,
          min: 9,
        )
        .toList(growable: false);
  });

  group('when the method generate is called', () {
    test(
      'solution should be valid for the board',
      () {
        final data = service.generate(emptySquares);

        final isSolutionValid = data.board.asMap().entries.every(
              (quadrant) => quadrant.value.asMap().entries.every(
                    (cell) =>
                        cell.value.value == 0 ||
                        cell.value.value ==
                            data.solution[quadrant.key][cell.key],
                  ),
            );

        expect(isSolutionValid, isTrue);
      },
    );

    test(
      'board should be correctly initialized',
      () {
        final data = service.generate(emptySquares);

        final isBoardUntouched = data.board.every(
          (quadrant) => quadrant.every((cell) {
            if (cell.value < 0 || cell.value > 9) {
              return false;
            }

            if (cell.editable && cell.value != 0 || cell.invalidValue) {
              return false;
            }

            return true;
          }),
        );

        expect(isBoardUntouched, isTrue);
      },
    );

    test(
      'should throw exception if input is invalid',
      () async {
        try {
          service.generate(0);
          expect(true, isFalse, reason: 'Expecting an exception!');
        } on Exception catch (error) {
          expect(error, isInstanceOf<Exception>());
        }
        try {
          // 54 is the higher valid value for unique solution generation
          service.generate(55);
          expect(true, isFalse, reason: 'Expecting an exception!');
        } on Exception catch (error) {
          expect(error, isInstanceOf<Exception>());
        }
      },
    );
  });

  group('when the method checkMove is called', () {});

  group('when the method move is called', () {});

  group('when the method checkCompleted is called', () {
    List<List<SudokuCellJTO>> genFilledBoard() => faker.randomGenerator
        .amount(
          (_) => faker.randomGenerator
              .amount(
                (_) => SudokuCellJTO(
                  value: faker.randomGenerator.integer(9, min: 1),
                ),
                9,
                min: 9,
              )
              .toList(growable: false),
          9,
          min: 9,
        )
        .toList(growable: false);

    test(
      'should return true when the board is all filled',
      () async {
        final completed = service.checkCompleted(genFilledBoard());
        expect(completed, isTrue);
      },
    );

    test(
      'should return false when the board is not completely filled',
      () async {
        final incompleteBoard = genFilledBoard();
        incompleteBoard[0][0] = const SudokuCellJTO(value: 0);
        final completed = service.checkCompleted(incompleteBoard);
        expect(completed, isFalse);
      },
    );
  });

  group('when the method checkSolved is called', () {
    test(
      'should return true when the board is equal to the solution',
      () async {
        final solution = randomBoard
            .map(
              (quadrant) =>
                  quadrant.map((cell) => cell.value).toList(growable: false),
            )
            .toList(growable: false);
        final mockData = SudokuDataJTO(
          board: randomBoard,
          solution: solution,
          emptySquares: emptySquares,
        );

        final solved = service.checkSolved(mockData);
        expect(solved, isTrue);
      },
    );

    test(
      'should return false when the board is not equal to the solution',
      () async {
        final solution = randomBoard
            .map(
              (quadrant) =>
                  quadrant.map((cell) => cell.value).toList(growable: false),
            )
            .toList(growable: false);
        solution[0][0] = -1;
        final mockData = SudokuDataJTO(
          board: randomBoard,
          solution: solution,
          emptySquares: emptySquares,
        );

        final solved = service.checkSolved(mockData);
        expect(solved, isFalse);
      },
    );
  });

  group('when the method addNote is called', () {
    late int quadrantIndex;
    late int cellIndex;
    late List<int> notes;

    setUp(() {
      quadrantIndex = faker.randomGenerator.integer(8);
      cellIndex = faker.randomGenerator.integer(8);
      notes = faker.randomGenerator.amount(
        (_) => faker.randomGenerator.integer(9, min: 1),
        9,
      );
    });

    List<List<SudokuCellJTO>> addNoteRecursive({
      required int noteIndex,
      required int quadrant,
      required int cellIndex,
      required List<List<SudokuCellJTO>> board,
    }) {
      final boardWithNote = service.addNote(
        quadrantIndex,
        cellIndex,
        notes[noteIndex],
        board,
      );

      if (noteIndex >= notes.length - 1) {
        return boardWithNote;
      }

      return addNoteRecursive(
        noteIndex: noteIndex + 1,
        quadrant: quadrant,
        cellIndex: cellIndex,
        board: boardWithNote,
      );
    }

    test(
      'if i add some notes the result should be a set of those notes',
      () async {
        final initialBoard = faker.randomGenerator
            .amount(
              (_) => SudokuCellJTOFixture.factory()
                  .withoutNotes()
                  .makeMany(9, growableList: false),
              9,
              min: 9,
            )
            .toList(growable: false);
        final editedBoard = addNoteRecursive(
          noteIndex: 0,
          quadrant: quadrantIndex,
          cellIndex: cellIndex,
          board: initialBoard,
        );

        final row = tfindCellRow(quadrantIndex, cellIndex);
        final col = tfindCellCol(quadrantIndex, cellIndex);

        expect(editedBoard[row][col].notes, notes.toSet());
      },
    );
  });
}
