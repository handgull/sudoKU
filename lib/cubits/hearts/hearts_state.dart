part of 'hearts_cubit.dart';

@freezed
sealed class HeartsState with _$HeartsState {
  const factory HeartsState.active([@Default(K.maxHearts) int hearts]) =
      ActiveHeartsState;

  const factory HeartsState.errorActivating() = ErrorActivatingHeartsState;

  const factory HeartsState.changingHearts(int hearts) =
      ChangingHeartsHeartsState;

  const factory HeartsState.errorChangingHearts(int hearts) =
      ErrorChangingHeartsHeartsState;

  const factory HeartsState.lowHearts(int hearts) = LowHeartsHeartsState;

  const factory HeartsState.noHearts() = NoHeartsHeartsState;
}
