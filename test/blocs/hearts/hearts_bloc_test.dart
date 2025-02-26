import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/blocs/hearts/hearts_bloc.dart';

void main() {
  late HeartsBloc bloc;

  setUp(() {
    bloc = HeartsBloc();
  });

  
  /// Testing the event [StartHeartsEvent]
  group('when the event StartHeartsEvent is added to the BLoC', () {
    blocTest<HeartsBloc, HeartsState>(
      'test that HeartsBloc emits HeartsState.loading when start is called',
      setUp: () {
        //TODO: setup the environment
      },
      build: () => bloc,
      act: (bloc) {
        bloc.start();
      },
      expect: () => <HeartsState>[
        //TODO: define the emitted HeartsState states
      ],
      verify: (_) {
        //TODO: verify that methods are invoked properly
      },
    );
  });
  
  /// Testing the event [ChangeLifeHeartsEvent]
  group('when the event ChangeLifeHeartsEvent is added to the BLoC', () {
    blocTest<HeartsBloc, HeartsState>(
      'test that HeartsBloc emits HeartsState.loading when changeLife is called',
      setUp: () {
        //TODO: setup the environment
      },
      build: () => bloc,
      act: (bloc) {
        bloc.changeLife();
      },
      expect: () => <HeartsState>[
        //TODO: define the emitted HeartsState states
      ],
      verify: (_) {
        //TODO: verify that methods are invoked properly
      },
    );
  });
  
}