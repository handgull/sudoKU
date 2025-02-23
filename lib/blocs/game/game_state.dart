part of 'game_bloc.dart';

@freezed
sealed class GameState with _$GameState {
  const factory GameState.starting() = StartingGameState;

  const factory GameState.running(SudokuData data) = RunningGameState;

  const factory GameState.lastInvalid(SudokuData data) = LastInvalidGameState;

  const factory GameState.errorStarting() = ErrorStartingGameState;

  const factory GameState.paused(SudokuData data) = PausedGameState;

  const factory GameState.errorTogglingPause(SudokuData data) =
      ErrorTogglingPauseGameState;

  const factory GameState.gameOver(SudokuData data) = GameOverGameState;

  const factory GameState.won(SudokuData data) = WonGameState;

  const factory GameState.moving(SudokuData data) = MovingGameState;

  const factory GameState.errorMoving(SudokuData data) = ErrorMovingGameState;
}
