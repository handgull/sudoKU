import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku/blocs/game/game_bloc.dart';
import 'package:sudoku/cubits/active_cell/active_cell_cubit.dart';
import 'package:sudoku/cubits/game_timer/game_timer_cubit.dart';
import 'package:sudoku/cubits/theme/theme_cubit.dart';
import 'package:sudoku/extensions/localized_context.dart';
import 'package:sudoku/misc/constants.dart';
import 'package:sudoku/mixins/snackbar_mixin.dart';
import 'package:sudoku/mixins/vibration_mixin.dart';
import 'package:sudoku/models/enums/difficulty.dart';
import 'package:sudoku/pages/game/widgets/board.dart';
import 'package:sudoku/pages/game/widgets/difficulty_dropdown.dart';
import 'package:sudoku/pages/game/widgets/game_time.dart';
import 'package:sudoku/pages/game/widgets/keyboard_numbers.dart';
import 'package:sudoku/routers/app_router.gr.dart';
import 'package:sudoku/widgets/main_app_bar.dart';

@RoutePage()
class GamePage extends StatelessWidget
    with SnackbarMixin, VibrationMixin
    implements AutoRouteWrapper {
  const GamePage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(
        create:
            (context) => GameBloc(
              gameRepository: context.read(),
              gameTimerRepository: context.read(),
            )..start(),
      ),
      BlocProvider(create: (context) => ActiveCellCubit()),
      BlocProvider(
        create:
            (context) => GameTimerCubit(gameTimerRepository: context.read()),
      ),
    ],
    child: this,
  );

  @override
  Widget build(BuildContext context) {
    final noteMode = Random().nextBool(); // TODO allacciare logica

    return BlocConsumer<GameBloc, GameState>(
      listener:
          (context, state) => switch (state) {
            ErrorStartingGameState() => _onErrorStarting(context),
            LastInvalidGameState() => vibrate(),
            _ => null,
          },
      builder: (context, gameState) {
        // TODO fare un hydratedcubit a parte
        final activeDifficulty = switch (gameState) {
          RunningGameState() => gameState.data.difficulty,
          LastInvalidGameState() => gameState.data.difficulty,
          WonGameState() => gameState.data.difficulty,
          GameOverGameState() => gameState.data.difficulty,
          _ => Difficulty.medium,
        };

        final gameData = switch (gameState) {
          RunningGameState() => gameState.data,
          PausedGameState() => gameState.data,
          LastInvalidGameState() => gameState.data,
          WonGameState() => gameState.data,
          GameOverGameState() => gameState.data,
          _ => null,
        };

        final boardStatus = switch (gameState) {
          PausedGameState() => BoardStatus.paused,
          WonGameState() => BoardStatus.finished,
          GameOverGameState() => BoardStatus.finished,
          _ => BoardStatus.running,
        };

        final lastInvalid = switch (gameState) {
          LastInvalidGameState() => true,
          _ => false,
        };

        return BlocBuilder<ActiveCellCubit, ActiveCellState>(
          builder: (context, cellState) {
            final activeCellIndexes = switch (cellState) {
              ActiveActiveCellState() => cellState,
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
                changeMode:
                    (mode) => context.read<ThemeCubit>().changeMode(mode),
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
                            context.read<ActiveCellCubit>().setActive(
                              null,
                              null,
                            );
                            context.read<GameBloc>().start(difficulty: value);
                          },
                          activeDifficulty: activeDifficulty,
                        ),
                        IconButton(
                          tooltip: context.t?.newGame,
                          onPressed: () {
                            context.read<ActiveCellCubit>().setActive(
                              null,
                              null,
                            );
                            context.read<GameBloc>().start(
                              difficulty: activeDifficulty,
                            );
                          },
                          icon: const Icon(Icons.restart_alt),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Center(
                        child: Board(
                          board: gameData?.board,
                          status: boardStatus,
                          errorState: lastInvalid,
                          activeQuadrant: activeCellIndexes?.quadrant,
                          activeQuadrantIndex: activeCellIndexes?.index,
                          onCellTap:
                              (quadrant, index) => context
                                  .read<ActiveCellCubit>()
                                  .setActive(quadrant, index),
                          restart: () {
                            if (gameData != null) {
                              context.read<GameBloc>().togglePause(gameData);
                            }
                          },
                        ),
                      ),
                    ),
                    BlocBuilder<GameTimerCubit, GameTimerState>(
                      builder: (context, gameTimerState) {
                        final seconds = switch (gameTimerState) {
                          TickedGameTimerState() => gameTimerState.seconds,
                          _ => null,
                        };

                        final status = switch (gameState) {
                          WonGameState() => GameTimeStatus.won,
                          GameOverGameState() => GameTimeStatus.lost,
                          _ => GameTimeStatus.waiting,
                        };

                        return GameTime(seconds: seconds, status: status);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6, bottom: 24),
                      child: KeyboardNumbers(
                        onNumberTap:
                            activeCellIndexes?.quadrant != null &&
                                    activeCellIndexes?.index != null &&
                                    gameData != null
                                ? (value) {
                                  context.read<GameBloc>().move(
                                    data: gameData,
                                    quadrant: activeCellIndexes!.quadrant!,
                                    index: activeCellIndexes.index!,
                                    value: value,
                                  );
                                }
                                : null,
                      ),
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
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
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

              floatingActionButton:
                  gameData != null && boardStatus != BoardStatus.finished
                      ? FloatingActionButton(
                        onPressed: () {
                          context.read<GameBloc>().togglePause(gameData);
                        },
                        tooltip:
                            boardStatus == BoardStatus.paused
                                ? context.t?.resume
                                : context.t?.pause,
                        child:
                            boardStatus == BoardStatus.paused
                                ? const Icon(Icons.play_arrow)
                                : const Icon(Icons.pause),
                      )
                      : const FloatingActionButton(onPressed: null),
            );
          },
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
