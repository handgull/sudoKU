part of 'hearts_cubit.dart';

int? findHearts(HeartsState state) => switch (state) {
      ActiveHeartsState() => state.hearts,
      ChangingHeartsHeartsState() => state.hearts,
      ErrorChangingHeartsHeartsState() => state.hearts,
      LowHeartsHeartsState() => state.hearts,
      _ => null,
    };
