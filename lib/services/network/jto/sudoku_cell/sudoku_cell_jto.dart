import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pine/pine.dart';

part 'sudoku_cell_jto.freezed.dart';
part 'sudoku_cell_jto.g.dart';

@freezed
class SudokuCellJTO extends DTO with _$SudokuCellJTO {
  const factory SudokuCellJTO({
    required int value,
    @Default(false) bool editable,
    @Default(false) bool invalidValue,
    @Default({}) Set<int> notes,
  }) = _SudokuCellJTO;

  factory SudokuCellJTO.fromJson(Map<String, dynamic> json) =>
      _$SudokuCellJTOFromJson(json);
}
