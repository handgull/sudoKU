import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/models/sudoku_cell/sudoku_cell.dart';
import 'package:sudoku/repositories/mappers/sudoku_cell_mapper.dart';
import 'package:sudoku/services/network/jto/sudoku_cell/sudoku_cell_jto.dart';
import '../../fixtures/jto/sudoku_cell_jto_fixture_factory.dart';

void main() {
  late SudokuCellMapper mapper;
  late SudokuCellJTO dto;
  late SudokuCell model;

  setUp(() {
    dto = SudokuCellJTOFixture.factory().makeSingle();

    model = SudokuCell(
      value: dto.value,
      editable: dto.editable,
      invalidValue: dto.invalidValue,
      notes: dto.notes,
    );
    mapper = const SudokuCellMapper();
  });

  test('mapping SudokuCell object from SudokuCellJTO', () {
    expect(mapper.fromDTO(dto), equals(model));
  });

  test('mapping SudokuCell to SudokuCellJTO', () {
    expect(mapper.toDTO(model), equals(dto));
  });
}
