part of 'game_bloc.dart';

@freezed
sealed class GameEvent with _$GameEvent {
  const factory GameEvent.start({
    @Default(Difficulty.medium) Difficulty difficulty,
  }) = StartGameEvent;

  const factory GameEvent.move() = MoveGameEvent;

  const factory GameEvent.togglePause() = TogglePauseGameEvent;
}
