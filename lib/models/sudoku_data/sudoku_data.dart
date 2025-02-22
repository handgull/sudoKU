import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sudoku/models/enums/difficulty.dart';

part 'sudoku_data.freezed.dart';

@freezed
class SudokuData with _$SudokuData {
  const factory SudokuData({
    required List<List<int>> board,
    required List<List<int>> solution,
    required Difficulty difficulty,
  }) = _SudokuData;
  const SudokuData._();
}
