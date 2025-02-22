part of 'game_timer_cubit.dart';

@freezed
sealed class GameTimerState with _$GameTimerState {
  const factory GameTimerState.initializing() = InitializingGameTimerState;

  const factory GameTimerState.ticked(int seconds) = TickedGameTimerState;

  const factory GameTimerState.errorTicking() = ErrorTickingGameTimerState;
}
