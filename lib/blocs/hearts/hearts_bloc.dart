import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:async';


part 'hearts_event.dart';

part 'hearts_state.dart';

part 'hearts_bloc.freezed.dart';

/// The HeartsBloc
class HeartsBloc extends Bloc<HeartsEvent, HeartsState> {
  /// Create a new instance of [HeartsBloc].
  HeartsBloc() : super(const HeartsState.loading()) {
    on<StartHeartsEvent>(_onStart);
    on<ChangeLifeHeartsEvent>(_onChangeLife);
    
  }
  
  /// Method used to add the [StartHeartsEvent] event
  void start() => add(const HeartsEvent.start());
  
  /// Method used to add the [ChangeLifeHeartsEvent] event
  void changeLife() => add(const HeartsEvent.changeLife());
  
  
  FutureOr<void> _onStart(
    StartHeartsEvent event,
    Emitter<HeartsState> emit,
  ) {
    //TODO: map StartHeartsEvent to HeartsState states
  }
  
  FutureOr<void> _onChangeLife(
    ChangeLifeHeartsEvent event,
    Emitter<HeartsState> emit,
  ) {
    //TODO: map ChangeLifeHeartsEvent to HeartsState states
  }
  
}

