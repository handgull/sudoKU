part of 'game_bloc.dart';

@freezed
sealed class GameState with _$GameState {
  const factory GameState.starting() = StartingGameState;

  const factory GameState.running(SudokuData data) = RunningGameState;

  const factory GameState.errorStarting() = ErrorStartingGameState;

  const factory GameState.paused(SudokuData data) = PausedGameState;

  const factory GameState.errorFreezing() = ErrorFreezingGameState;

  const factory GameState.gameOver(SudokuData data) = GameOverGameState;

  const factory GameState.won(SudokuData data) = WonGameState;

  const factory GameState.moving() = MovingGameState;

  const factory GameState.errorMoving() = ErrorMovingGameState;
}
