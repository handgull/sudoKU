import 'package:pine/pine.dart';
import 'package:sudoku/models/sudoku_cell/sudoku_cell.dart';
import 'package:sudoku/services/network/jto/sudoku_cell/sudoku_cell_jto.dart';

class SudokuCellMapper extends DTOMapper<SudokuCellJTO, SudokuCell> {
  const SudokuCellMapper();

  @override
  SudokuCell fromDTO(SudokuCellJTO dto) => SudokuCell(
    value: dto.value,
    editable: dto.editable,
    invalidValue: dto.invalidValue,
    notes: dto.notes,
  );

  @override
  SudokuCellJTO toDTO(SudokuCell model) => SudokuCellJTO(
    value: model.value,
    editable: model.editable,
    invalidValue: model.invalidValue,
    notes: model.notes,
  );
}
