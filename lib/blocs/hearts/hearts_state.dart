part of 'hearts_bloc.dart';

@freezed
sealed class HeartsState with _$HeartsState {
  
  const factory HeartsState.loading() = LoadingHeartsState;
  
  const factory HeartsState.active() = ActiveHeartsState;
  
  const factory HeartsState.errorActivating() = ErrorActivatingHeartsState;
  
  const factory HeartsState.changingHearts() = ChangingHeartsHeartsState;
  
  const factory HeartsState.errorChangingHearts() = ErrorChangingHeartsHeartsState;
  
  const factory HeartsState.lowHearts() = LowHeartsHeartsState;
  
  const factory HeartsState.noHearts() = NoHeartsHeartsState;
  
}
