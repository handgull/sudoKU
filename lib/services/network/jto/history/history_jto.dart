import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pine/pine.dart';
import 'package:sudoku/models/enums/difficulty.dart';

part 'history_jto.freezed.dart';
part 'history_jto.g.dart';

@freezed
class HistoryJTO extends DTO with _$HistoryJTO {
  const factory HistoryJTO({@Default([]) List<HistoryEntryJTO> entries}) =
      _HistoryJTO;

  factory HistoryJTO.fromJson(Map<String, dynamic> json) =>
      _$HistoryJTOFromJson(json);
}

@freezed
class HistoryEntryJTO extends DTO with _$HistoryEntryJTO {
  const factory HistoryEntryJTO({
    required DateTime dateTime,
    required int gameDuration,
    required Difficulty difficulty,
  }) = _HistoryEntryJTO;

  factory HistoryEntryJTO.fromJson(Map<String, dynamic> json) =>
      _$HistoryEntryJTOFromJson(json);
}
