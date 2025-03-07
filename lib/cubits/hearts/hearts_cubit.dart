import 'dart:async';
import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:sudoku/misc/constants.dart';

part 'hearts_cubit.freezed.dart';
part 'hearts_state.dart';
part 'hearts_state_utils.dart';

class HeartsCubit extends HydratedCubit<HeartsState> {
  HeartsCubit() : super(const HeartsState.active());

  FutureOr<void> start() {
    // If you switch to a remote API or a local database,
    // this method will be populated.
  }

  FutureOr<void> changeLife(int damage) {
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
    final newHearts = min(hearts + damage, K.maxHearts);
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
    if (jsonHearts != null && jsonHearts > 1) {
      return HeartsState.active(jsonHearts);
    } else if (jsonHearts == 1) {
      return HeartsState.lowHearts(jsonHearts!);
    } else if ((jsonHearts ?? 0) < 1) {
      return const HeartsState.noHearts();
    } else {
      return const HeartsState.active();
    }
  }

  @override
  Map<String, dynamic>? toJson(HeartsState state) {
    final hearts = findHearts(state);

    if (hearts != null) {
      return {'hearts': hearts};
    }
    return {};
  }
}
