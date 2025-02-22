import 'package:freezed_annotation/freezed_annotation.dart';

part 'sudoku_cell.freezed.dart';

@freezed
class SudokuCell with _$SudokuCell {
  const factory SudokuCell({
    required int value,
    @Default(false) bool editable,
    @Default(false) bool invalidValue,
    @Default({}) Set<int> notes,
  }) = _SudokuCell;
  const SudokuCell._();
}
