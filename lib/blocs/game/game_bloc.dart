import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sudoku/models/enums/difficulty.dart';
import 'package:sudoku/models/sudoku_cell/sudoku_cell.dart';
import 'package:sudoku/models/sudoku_data/sudoku_data.dart';
import 'package:sudoku/repositories/game_repository.dart';
import 'package:sudoku/repositories/game_timer_repository.dart';

part 'game_bloc.freezed.dart';
part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc({required this.gameRepository, required this.gameTimerRepository})
    : super(const GameState.starting()) {
    on<StartGameEvent>(_onStart);
    on<MoveGameEvent>(_onMove);
    on<TogglePauseGameEvent>(_onTogglePause);
  }

  final GameRepository gameRepository;
  final GameTimerRepository gameTimerRepository;

  void start({Difficulty difficulty = Difficulty.medium}) =>
      add(GameEvent.start(difficulty: difficulty));
  void move({
    required SudokuData data,
    required int quadrant,
    required int index,
    required int value,
  }) => add(
    GameEvent.move(data: data, quadrant: quadrant, index: index, value: value),
  );
  void togglePause(SudokuData data) => add(GameEvent.togglePause(data));

  FutureOr<void> _onStart(StartGameEvent event, Emitter<GameState> emit) {
    try {
      emit(const GameState.starting());
      final data = gameRepository.generate(event.difficulty);
      gameTimerRepository.start();
      emit(GameState.running(data));
    } on Exception catch (_) {
      emit(const GameState.errorStarting());
    }
  }

  FutureOr<void> _onMove(MoveGameEvent event, Emitter<GameState> emit) {
    try {
      emit(GameState.moving(event.data));
      final validMove = gameRepository.checkMove(
        event.quadrant,
        event.index,
        event.value,
        event.data.board,
      );
      final newBoard = gameRepository.move(
        event.quadrant,
        event.index,
        SudokuCell(
          value: event.value,
          editable: true,
          invalidValue: !validMove,
        ),
        event.data.board,
      );
      final data = event.data.copyWith(board: newBoard);

      if (validMove) {
        emit(GameState.running(data));
      } else {
        emit(GameState.lastInvalid(data));
      }

      final completed = gameRepository.checkCompleted(data.board);
      final solved = gameRepository.checkSolved(data);

      if (solved) {
        gameTimerRepository.togglePause();
        emit(GameState.won(data));
      } else if (completed) {
        gameTimerRepository.togglePause();
        emit(GameState.gameOver(data));
      }
    } on Exception catch (_) {
      emit(const GameState.errorStarting());
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
}
