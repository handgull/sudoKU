part of 'game_bloc.dart';

Difficulty findActiveDifficulty(GameState state) => switch (state) {
      RunningGameState() => state.data.difficulty,
      PausedGameState() => state.data.difficulty,
      LastInvalidGameState() => state.data.difficulty,
      WonGameState() => state.data.difficulty,
      GameOverGameState() => state.data.difficulty,
      MovingGameState() => state.data.difficulty,
      ErrorMovingGameState() => state.data.difficulty,
      AddingNoteGameState() => state.data.difficulty,
      ErrorAddingNoteGameState() => state.data.difficulty,
      _ => Difficulty.medium,
    };

SudokuData? findGameData(GameState state) => switch (state) {
      RunningGameState() => state.data,
      PausedGameState() => state.data,
      LastInvalidGameState() => state.data,
      WonGameState() => state.data,
      GameOverGameState() => state.data,
      MovingGameState() => state.data,
      ErrorMovingGameState() => state.data,
      AddingNoteGameState() => state.data,
      ErrorAddingNoteGameState() => state.data,
      _ => null,
    };

BoardStatus findBoardStatus(GameState state) => switch (state) {
      PausedGameState() => BoardStatus.paused,
      WonGameState() => BoardStatus.won,
      GameOverGameState() => BoardStatus.lost,
      _ => BoardStatus.running,
    };

bool findLastInvalid(GameState state) => switch (state) {
      LastInvalidGameState() => true,
      _ => false,
    };
