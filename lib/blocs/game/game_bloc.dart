import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sudoku/models/enums/difficulty.dart';
import 'package:sudoku/models/sudoku_data/sudoku_data.dart';
import 'package:sudoku/repositories/game_repository.dart';

part 'game_bloc.freezed.dart';
part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc({required this.gameRepository}) : super(const GameState.starting()) {
    on<StartGameEvent>(_onStart);
    on<MoveGameEvent>(_onMove);
    on<TogglePauseGameEvent>(_onTogglePause);
  }

  final GameRepository gameRepository;

  void start({Difficulty difficulty = Difficulty.medium}) =>
      add(GameEvent.start(difficulty: difficulty));
  void move() => add(const GameEvent.move());
  void togglePause() => add(const GameEvent.togglePause());

  FutureOr<void> _onStart(StartGameEvent event, Emitter<GameState> emit) {
    emit(const GameState.starting());
    try {
      final data = gameRepository.generate(event.difficulty);
      emit(GameState.running(data));
    } on Exception catch (_) {
      emit(const GameState.errorStarting());
    }
  }

  FutureOr<void> _onMove(MoveGameEvent event, Emitter<GameState> emit) {
    //TODO: map MoveGameEvent to GameState states
  }

  FutureOr<void> _onTogglePause(
    TogglePauseGameEvent event,
    Emitter<GameState> emit,
  ) {
    //TODO: map TogglePauseGameEvent to GameState states
  }
}

extension on BuildContext {
  GameBloc get gameBloc => read<GameBloc>();
}
