import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sudoku/repositories/game_timer_repository.dart';

part 'game_timer_cubit.freezed.dart';
part 'game_timer_state.dart';

// This cubit is readonly
// because blocs can't emit values in an aeasy way with streams
class GameTimerCubit extends Cubit<GameTimerState> {
  GameTimerCubit({required this.gameTimerRepository})
    : super(const GameTimerState.initializing()) {
    _timerSubscription = gameTimerRepository.timer.listen(_onTimerTick);
  }

  final GameTimerRepository gameTimerRepository;
  late StreamSubscription<int> _timerSubscription;

  FutureOr<void> _onTimerTick(int seconds) {
    try {
      emit(TickedGameTimerState(seconds));
    } on Exception catch (_) {
      emit(const ErrorTickingGameTimerState());
    }
  }

  @override
  Future<void> close() async {
    await _timerSubscription.cancel();
    gameTimerRepository.close();

    return super.close();
  }
}
