import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:sudoku/models/enums/difficulty.dart';
import 'package:sudoku/models/sudoku_cell/sudoku_cell.dart';
import 'package:sudoku/models/sudoku_data/sudoku_data.dart';
import 'package:sudoku/pages/game/widgets/board/board.dart';
import 'package:sudoku/repositories/game_repository.dart';
import 'package:sudoku/repositories/game_timer_repository.dart';

part 'game_bloc.freezed.dart';
part 'game_event.dart';
part 'game_state.dart';
part 'game_state_utils.dart';

class GameBloc extends HydratedBloc<GameEvent, GameState> {
  GameBloc({required this.gameRepository, required this.gameTimerRepository})
      : super(const GameState.starting()) {
    on<StartGameEvent>(_onStart);
    on<MoveGameEvent>(_onMove);
    on<TogglePauseGameEvent>(_onTogglePause);
    on<AddNoteGameEvent>(_onAddNote);
    on<NoHeartsGameEvent>(_onNoHearts);
  }

  final GameRepository gameRepository;
  final GameTimerRepository gameTimerRepository;

  void start({
    Difficulty difficulty = Difficulty.medium,
    bool overrideCurrent = false,
  }) =>
      add(
        GameEvent.start(
          difficulty: difficulty,
          overrideCurrent: overrideCurrent,
        ),
      );

  void move({
    required int quadrant,
    required int index,
    required int value,
  }) =>
      add(
        GameEvent.move(
          quadrant: quadrant,
          index: index,
          value: value,
        ),
      );

  void togglePause(SudokuData data) => add(GameEvent.togglePause(data));

  void addNote({
    required SudokuData data,
    required int quadrant,
    required int index,
    required int value,
  }) =>
      add(
        GameEvent.addNote(
          data: data,
          quadrant: quadrant,
          index: index,
          value: value,
        ),
      );

  void noHearts() => add(
        const GameEvent.noHearts(),
      );

  FutureOr<void> _onStart(StartGameEvent event, Emitter<GameState> emit) {
    try {
      final havePendingData = switch (state) {
        RunningGameState() => true,
        LastInvalidGameState() => true,
        PausedGameState() => true,
        ErrorTogglingPauseGameState() => true,
        MovingGameState() => true,
        ErrorMovingGameState() => true,
        _ => false,
      };

      if (!event.overrideCurrent && havePendingData) {
        return null;
      }

      emit(const GameState.starting());
      final data = gameRepository.generate(event.difficulty);
      gameTimerRepository.start();
      emit(GameState.running(data));
    } on Exception catch (_) {
      emit(const GameState.errorStarting());
    }
  }

  FutureOr<void> _onMove(MoveGameEvent event, Emitter<GameState> emit) {
    final data = switch (state) {
      RunningGameState() => (state as RunningGameState).data,
      LastInvalidGameState() => (state as LastInvalidGameState).data,
      PausedGameState() => (state as PausedGameState).data,
      ErrorTogglingPauseGameState() =>
        (state as ErrorTogglingPauseGameState).data,
      MovingGameState() => (state as MovingGameState).data,
      ErrorMovingGameState() => (state as ErrorMovingGameState).data,
      _ => null,
    };

    if (data == null) {
      return null;
    }

    try {
      emit(GameState.moving(data));
      final validMove = gameRepository.checkMove(
        event.quadrant,
        event.index,
        event.value,
        data.board,
      );
      final newBoard = gameRepository.move(
        event.quadrant,
        event.index,
        SudokuCell(
          value: event.value,
          editable: true,
          invalidValue: !validMove,
        ),
        data.board,
      );
      final newData = data.copyWith(board: newBoard);

      if (validMove) {
        emit(GameState.running(newData));
      } else {
        emit(GameState.lastInvalid(newData));
      }

      final completed = gameRepository.checkCompleted(newData.board);
      final solved = completed && gameRepository.checkSolved(newData);

      if (solved) {
        gameTimerRepository.togglePause();
        emit(GameState.won(newData));
      } else if (completed) {
        gameTimerRepository.togglePause();
        emit(GameState.gameOver(newData));
      }
    } on Exception catch (_) {
      emit(GameState.errorMoving(data));
    }
  }

  FutureOr<void> _onTogglePause(
    TogglePauseGameEvent event,
    Emitter<GameState> emit,
  ) {
    try {
      gameTimerRepository.togglePause();

      if (gameTimerRepository.paused) {
        emit(PausedGameState(event.data));
      } else {
        emit(RunningGameState(event.data));
      }
    } on Exception catch (_) {
      emit(GameState.errorTogglingPause(event.data));
    }
  }

  FutureOr<void> _onAddNote(AddNoteGameEvent event, Emitter<GameState> emit) {
    try {
      emit(GameState.addingNote(event.data));
      final newBoard = gameRepository.addNote(
        event.quadrant,
        event.index,
        event.value,
        event.data.board,
      );
      final data = event.data.copyWith(board: newBoard);

      emit(GameState.running(data));
    } on Exception catch (_) {
      emit(GameState.errorAddingNote(event.data));
    }
  }

  FutureOr<void> _onNoHearts(NoHeartsGameEvent event, Emitter<GameState> emit) {
    final data = findGameData(state);
    if (data == null) {
      return null;
    }
    gameTimerRepository.togglePause();
    emit(GameState.gameOver(data));
  }

  @override
  GameState? fromJson(Map<String, dynamic> json) {
    if (json.containsKey('sudokuData')) {
      return GameState.running(
        SudokuData.fromJson(json['sudokuData'] as Map<String, dynamic>),
      );
    }
    return null;
  }

  @override
  Map<String, dynamic>? toJson(GameState state) => switch (state) {
        StartingGameState() => {},
        ErrorStartingGameState() => {},
        WonGameState() => {},
        GameOverGameState() => {},
        RunningGameState() => {'sudokuData': state.data.toJson()},
        LastInvalidGameState() => {'sudokuData': state.data.toJson()},
        PausedGameState() => {'sudokuData': state.data.toJson()},
        ErrorTogglingPauseGameState() => {'sudokuData': state.data.toJson()},
        MovingGameState() => {'sudokuData': state.data.toJson()},
        ErrorMovingGameState() => {'sudokuData': state.data.toJson()},
        AddingNoteGameState() => {'sudokuData': state.data.toJson()},
        ErrorAddingNoteGameState() => {'sudokuData': state.data.toJson()},
      };
}
