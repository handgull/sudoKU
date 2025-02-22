import 'dart:developer';
import 'dart:math' hide log;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku/blocs/game/game_bloc.dart';
import 'package:sudoku/cubits/theme/theme_cubit.dart';
import 'package:sudoku/extensions/localized_context.dart';
import 'package:sudoku/misc/constants.dart';
import 'package:sudoku/mixins/snackbar_mixin.dart';
import 'package:sudoku/models/enums/difficulty.dart';
import 'package:sudoku/models/sudoku_cell/sudoku_cell.dart';
import 'package:sudoku/pages/game/widgets/board.dart';
import 'package:sudoku/pages/game/widgets/difficulty_dropdown.dart';
import 'package:sudoku/pages/game/widgets/keyboard_numbers.dart';
import 'package:sudoku/routers/app_router.gr.dart';
import 'package:sudoku/widgets/main_app_bar.dart';

@RoutePage()
class GamePage extends StatelessWidget
    with SnackbarMixin
    implements AutoRouteWrapper {
  const GamePage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => GameBloc(gameRepository: context.read())..start(),
      ),
    ],
    child: this,
  );

  @override
  Widget build(BuildContext context) {
    final noteMode = Random().nextBool(); // TODO allacciare logica
    final paused = Random().nextBool(); // TODO allacciare logica

    return BlocConsumer<GameBloc, GameState>(
      listener:
          (context, state) => switch (state) {
            RunningGameState() => log(state.data.toString()),
            ErrorStartingGameState() => _onErrorStarting(context),
            _ => debugPrint(state.runtimeType.toString()),
          },
      builder: (context, state) {
        final activeDifficulty = switch (state) {
          RunningGameState() => state.data.difficulty,
          _ => Difficulty.medium,
        };

        final gameData = switch (state) {
          RunningGameState() => state.data.board,
          ErrorStartingGameState() => <List<SudokuCell>>[],
          _ => null,
        };

        return Scaffold(
          appBar: MainAppBar(
            leading: BackButton(
              onPressed: () {
                if (context.router.canPop()) {
                  context.router.maybePop();
                } else {
                  context.router.replace(const StatsRoute());
                }
              },
            ),
            changeMode: (mode) => context.read<ThemeCubit>().changeMode(mode),
          ),
          body: Padding(
            padding: const EdgeInsets.all(K.pagesPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DifficultyDropdown(
                      onDifficultyChanged: (value) {
                        context.read<GameBloc>().start(difficulty: value);
                      },
                      activeDifficulty: activeDifficulty,
                    ),
                    IconButton(
                      tooltip: context.t?.newGame,
                      onPressed: () {
                        context.read<GameBloc>().start(
                          difficulty: activeDifficulty,
                        );
                      },
                      icon: const Icon(Icons.restart_alt),
                    ),
                  ],
                ),
                Expanded(child: Center(child: Board(board: gameData))),
                const Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: KeyboardNumbers(),
                ),
                Row(
                  spacing: 16,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlinedButton(
                      onPressed: () {},
                      style:
                          noteMode
                              ? ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                              )
                              : null,
                      child: Row(
                        spacing: 8,
                        children: [
                          Icon(
                            Icons.edit_note,
                            color: noteMode ? Colors.white : null,
                          ),
                          Text(
                            noteMode
                                ? context.t?.notesOn ?? 'NOTES_ON'
                                : context.t?.notesOff ?? 'NOTES_OFF',
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: Row(
                        spacing: 8,
                        children: [
                          const Icon(Icons.edit_off),
                          Text(context.t?.erase ?? 'ERASE'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            tooltip: paused ? context.t?.resume : context.t?.pause,
            child:
                paused ? const Icon(Icons.play_arrow) : const Icon(Icons.pause),
          ),
        );
      },
    );
  }

  void _onErrorStarting(BuildContext context) {
    showSnackbar(
      context,
      backgroundColor: Colors.red,
      message: Text(context.t?.errorStartingGame ?? 'ERROR_STARTING_GAME'),
    );
  }
}
