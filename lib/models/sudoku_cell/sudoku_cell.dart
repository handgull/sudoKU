import 'package:freezed_annotation/freezed_annotation.dart';

part 'sudoku_cell.freezed.dart';
part 'sudoku_cell.g.dart';

@freezed
class SudokuCell with _$SudokuCell {
  const factory SudokuCell({
    required int value,
    @Default(false) bool editable,
    @Default(false) bool invalidValue,
    @Default({}) Set<int> notes,
  }) = _SudokuCell;
  const SudokuCell._();

  factory SudokuCell.fromJson(Map<String, dynamic> json) =>
      _$SudokuCellFromJson(json);
}
