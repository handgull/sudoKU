import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:sudoku/repositories/game_timer_repository.dart';

part 'game_timer_cubit.freezed.dart';
part 'game_timer_state.dart';

// This cubit is readonly
// because blocs can't emit values in an easy way when listening to streams
class GameTimerCubit extends HydratedCubit<GameTimerState> {
  GameTimerCubit({required this.gameTimerRepository})
      : super(const GameTimerState.initializing()) {
    _timerSubscription = gameTimerRepository.timer.listen(
      _onTimerTick,
      onError: (error) {
        emit(const ErrorTickingGameTimerState());
      },
    );
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
  GameTimerState? fromJson(Map<String, dynamic> json) {
    final seconds = json['secondsLasted'] as int;
    gameTimerRepository.start(seconds);
    return GameTimerState.ticked(seconds);
  }

  @override
  Map<String, dynamic>? toJson(GameTimerState state) => switch (state) {
        TickedGameTimerState() => {'secondsLasted': state.seconds},
        _ => null,
      };

  @override
  Future<void> close() async {
    await _timerSubscription.cancel();
    await gameTimerRepository.close();

    return super.close();
  }
}
