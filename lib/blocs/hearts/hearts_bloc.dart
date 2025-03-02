import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'hearts_bloc.freezed.dart';
part 'hearts_event.dart';
part 'hearts_state.dart';

class HeartsBloc extends HydratedBloc<HeartsEvent, HeartsState> {
  HeartsBloc() : super(const HeartsState.active()) {
    on<StartHeartsEvent>(_onStart);
    on<ChangeLifeHeartsEvent>(_onChangeLife);
  }

  void start() => add(const HeartsEvent.start());

  void changeLife(int damage) => add(HeartsEvent.changeLife(damage));

  FutureOr<void> _onStart(
    StartHeartsEvent event,
    Emitter<HeartsState> emit,
  ) {
    // If you switch to a remote API or a local database,
    // this method will be populated.
  }

  FutureOr<void> _onChangeLife(
    ChangeLifeHeartsEvent event,
    Emitter<HeartsState> emit,
  ) {
    final hearts = switch (state) {
      ActiveHeartsState() => (state as ActiveHeartsState).hearts,
      ErrorChangingHeartsHeartsState() =>
        (state as ErrorChangingHeartsHeartsState).hearts,
      LowHeartsHeartsState() => (state as LowHeartsHeartsState).hearts,
      ChangingHeartsHeartsState() =>
        (state as ChangingHeartsHeartsState).hearts,
      _ => 0,
    };

    emit(HeartsState.changingHearts(hearts));
    final newHearts = hearts + event.damage;
    if (newHearts > 1) {
      emit(HeartsState.active(newHearts));
    } else if (newHearts == 1) {
      emit(HeartsState.lowHearts(newHearts));
    } else {
      emit(const HeartsState.noHearts());
    }
  }

  @override
  HeartsState? fromJson(Map<String, dynamic> json) {
    final jsonHearts = json['hearts'] as int?;
    if (jsonHearts != null) {
      return HeartsState.active(jsonHearts);
    } else {
      return const HeartsState.active();
    }
  }

  @override
  Map<String, dynamic>? toJson(HeartsState state) => switch (state) {
        ActiveHeartsState() => {'hearts': state.hearts},
        ErrorActivatingHeartsState() => {},
        ChangingHeartsHeartsState() => {'hearts': state.hearts},
        ErrorChangingHeartsHeartsState() => {'hearts': state.hearts},
        LowHeartsHeartsState() => {'hearts': state.hearts},
        NoHeartsHeartsState() => {},
      };
}
