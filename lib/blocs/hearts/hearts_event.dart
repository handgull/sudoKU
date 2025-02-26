part of 'hearts_bloc.dart';

@freezed
sealed class HeartsEvent with _$HeartsEvent {
  
  const factory HeartsEvent.start() = StartHeartsEvent;
  
  const factory HeartsEvent.changeLife() = ChangeLifeHeartsEvent;
  
}
