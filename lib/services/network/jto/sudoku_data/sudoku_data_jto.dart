import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pine/pine.dart';

part 'sudoku_data_jto.freezed.dart';
part 'sudoku_data_jto.g.dart';

@freezed
class SudokuDataJTO extends DTO with _$SudokuDataJTO {
  const factory SudokuDataJTO({
    required List<List<int>> board,
    required List<List<int>> solution,
    required int emptySquares,
  }) = _SudokuDataJTO;

  factory SudokuDataJTO.fromJson(Map<String, dynamic> json) =>
      _$SudokuDataJTOFromJson(json);
}
