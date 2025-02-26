import 'package:data_fixture_dart/data_fixture_dart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/services/game_service.dart';
import 'package:sudoku/services/network/jto/sudoku_cell/sudoku_cell_jto.dart';
import 'package:sudoku/services/network/jto/sudoku_data/sudoku_data_jto.dart';

import '../../fixtures/jto/sudoku_cell_jto_fixture_factory.dart';
import '../../fixtures/jto/sudoku_data_jto_fixture_factory.dart';
import '../../misc/game_mechanics.dart';

void main() {
  late GameService service;
  late int emptySquares;
  late List<List<SudokuCellJTO>> randomBoard;
  late int quadrantIndex;
  late int cellIndex;
  late int invalidIndex;
  late SudokuCellJTO cell;

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
    quadrantIndex = faker.randomGenerator.integer(8);
    cellIndex = faker.randomGenerator.integer(8);
    invalidIndex = faker.randomGenerator.element([
      faker.randomGenerator.integer(100) - 101,
      faker.randomGenerator.integer(100, min: 9),
    ]);
    cell = SudokuCellJTOFixture.factory().makeSingle();
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
      () {
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

  group('when the method checkMove is called', () {
    test(
      'if i place the same number in a row the move should be invalid',
      () {
        const centerQuadrant = 4;
        const centerCellIndex = 4;
        final row = tfindCellRow(centerQuadrant, centerCellIndex);
        final col = tfindCellCol(centerQuadrant, centerCellIndex);
        final validMove = service.checkMove(
          centerQuadrant,
          centerCellIndex,
          randomBoard[row][col + 2].value,
          randomBoard,
        );

        expect(validMove, isFalse);
      },
    );

    test(
      'if i place the same number in a column the move should be invalid',
      () {
        const centerQuadrant = 4;
        const centerCellIndex = 4;
        final row = tfindCellRow(centerQuadrant, centerCellIndex);
        final col = tfindCellCol(centerQuadrant, centerCellIndex);
        final validMove = service.checkMove(
          centerQuadrant,
          centerCellIndex,
          randomBoard[row + 2][col].value,
          randomBoard,
        );

        expect(validMove, isFalse);
      },
    );

    test(
      'if i place the same number in a quadrant the move should be invalid',
      () {
        const centerQuadrant = 4;
        const centerCellIndex = 4;
        final row = tfindCellRow(centerQuadrant, centerCellIndex);
        final col = tfindCellCol(centerQuadrant, centerCellIndex);
        final validMove = service.checkMove(
          centerQuadrant,
          centerCellIndex,
          randomBoard[row + 1][col + 1].value,
          randomBoard,
        );

        expect(validMove, isFalse);
      },
    );

    test(
      'if i place a value not in the 0-9 range should be fail',
      () {
        try {
          final data = SudokuDataJTOFixture.factory().makeSingle();
          final invalidValue = faker.randomGenerator.element([
            ...List.generate(25, (i) => i - 24),
            ...List.generate(25, (i) => i + 10),
          ]);
          service.checkMove(
            quadrantIndex,
            cellIndex,
            invalidValue,
            data.board,
          );
          expect(true, isFalse, reason: 'Expecting an exception!');
        } on Exception catch (error) {
          expect(error, isInstanceOf<Exception>());
        }
      },
    );

    test(
      'if i provide an invalid position of the cell should fail',
      () {
        final data = SudokuDataJTOFixture.factory().makeSingle();
        expect(
          () => service.checkMove(
            quadrantIndex,
            invalidIndex,
            cell.value,
            data.board,
          ),
          throwsA(isA<RangeError>()),
        );
        expect(
          () => service.checkMove(
            invalidIndex,
            cellIndex,
            cell.value,
            data.board,
          ),
          throwsA(isA<RangeError>()),
        );
      },
    );

    test(
      'trying some random moves and checking validity',
      () {
        for (var row = 0; row < 9; row++) {
          final col = faker.randomGenerator.integer(8);
          final data = service.generate(54);
          final quadrant = tfindCellQuadrant(row, col);
          final cellPosition = tfindCellIndex(row, col);
          final randomValidValue = faker.randomGenerator.integer(9);
          final validMove = service.checkMove(
            quadrant,
            cellPosition,
            randomValidValue,
            data.board,
          );
          expect(
            validMove,
            tcheckMove(
              quadrant,
              cellPosition,
              randomValidValue,
              data.board,
            ),
          );
        }
      },
    );
  });

  group('when the method move is called', () {
    test(
      'after move the cell is correctly valorized',
      () {
        final row = tfindCellRow(quadrantIndex, cellIndex);
        final col = tfindCellCol(quadrantIndex, cellIndex);
        final boardWithMove = service.move(
          quadrantIndex,
          cellIndex,
          cell,
          genFilledBoard(),
        );

        expect(boardWithMove[row][col], cell);
      },
    );
  });

  group('when the method checkCompleted is called', () {
    test(
      'should return true when the board is all filled',
      () {
        final completed = service.checkCompleted(genFilledBoard());
        expect(completed, isTrue);
      },
    );

    test(
      'should return false when the board is not completely filled',
      () {
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
      () {
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
      () {
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
    late List<int> notes;

    setUp(() {
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
      () {
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

/*
4 quadrant
4 cell
idem


4 quadrant
8 cell

5 row
5 row
*/
