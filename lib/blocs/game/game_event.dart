part of 'game_bloc.dart';

@freezed
sealed class GameEvent with _$GameEvent {
  const factory GameEvent.start({
    @Default(Difficulty.medium) Difficulty difficulty,
    @Default(false) bool overrideCurrent,
  }) = StartGameEvent;

  const factory GameEvent.move({
    required int quadrant,
    required int index,
    required int value,
  }) = MoveGameEvent;

  const factory GameEvent.togglePause(SudokuData data) = TogglePauseGameEvent;

  const factory GameEvent.addNote({
    required SudokuData data,
    required int quadrant,
    required int index,
    required int value,
  }) = AddNoteGameEvent;

  const factory GameEvent.noHearts() = NoHeartsGameEvent;
}
