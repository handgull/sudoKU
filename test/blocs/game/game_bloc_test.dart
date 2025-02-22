import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/blocs/game/game_bloc.dart';

void main() {
  late GameBloc bloc;

  setUp(() {
    bloc = GameBloc();
  });

  
  /// Testing the event [StartGameEvent]
  group('when the event StartGameEvent is added to the BLoC', () {
    blocTest<GameBloc, GameState>(
      'test that GameBloc emits GameState.starting when start is called',
      setUp: () {
        //TODO: setup the environment
      },
      build: () => bloc,
      act: (bloc) {
        bloc.start();
      },
      expect: () => <GameState>[
        //TODO: define the emitted GameState states
      ],
      verify: (_) {
        //TODO: verify that methods are invoked properly
      },
    );
  });
  
  /// Testing the event [MoveGameEvent]
  group('when the event MoveGameEvent is added to the BLoC', () {
    blocTest<GameBloc, GameState>(
      'test that GameBloc emits GameState.starting when move is called',
      setUp: () {
        //TODO: setup the environment
      },
      build: () => bloc,
      act: (bloc) {
        bloc.move();
      },
      expect: () => <GameState>[
        //TODO: define the emitted GameState states
      ],
      verify: (_) {
        //TODO: verify that methods are invoked properly
      },
    );
  });
  
  /// Testing the event [TogglePauseGameEvent]
  group('when the event TogglePauseGameEvent is added to the BLoC', () {
    blocTest<GameBloc, GameState>(
      'test that GameBloc emits GameState.starting when togglePause is called',
      setUp: () {
        //TODO: setup the environment
      },
      build: () => bloc,
      act: (bloc) {
        bloc.togglePause();
      },
      expect: () => <GameState>[
        //TODO: define the emitted GameState states
      ],
      verify: (_) {
        //TODO: verify that methods are invoked properly
      },
    );
  });
  
}