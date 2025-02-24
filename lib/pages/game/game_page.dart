import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku/blocs/game/game_bloc.dart';
import 'package:sudoku/cubits/active_cell/active_cell_cubit.dart';
import 'package:sudoku/cubits/game_timer/game_timer_cubit.dart';
import 'package:sudoku/cubits/notes_mode/notes_mode_cubit.dart';
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
import 'package:sudoku/widgets/main_app_bar.dart';

@RoutePage()
class GamePage extends StatelessWidget
    with SnackbarMixin, VibrationMixin
    implements AutoRouteWrapper {
  const GamePage({super.key});

  // All the blocs relevant to the business logic of the game
  // are connected with the page lifecycle (but the repositories are global)
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
      BlocProvider(create: (_) => NotesModeCubit()),
    ],
    child: this,
  );

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameBloc, GameState>(
      // In this demo is used the dart 3 pattern matching to handle states
      // before dart 3 this was done with some freezed methods or manually
      listener:
          (context, state) => switch (state) {
            ErrorStartingGameState() => _onErrorStarting(context),
            LastInvalidGameState() => vibrate(),
            _ => null,
          },
      builder: (context, gameState) {
        final activeDifficulty = switch (gameState) {
          RunningGameState() => gameState.data.difficulty,
          PausedGameState() => gameState.data.difficulty,
          LastInvalidGameState() => gameState.data.difficulty,
          WonGameState() => gameState.data.difficulty,
          GameOverGameState() => gameState.data.difficulty,
          MovingGameState() => gameState.data.difficulty,
          ErrorMovingGameState() => gameState.data.difficulty,
          AddingNoteGameState() => gameState.data.difficulty,
          ErrorAddingNoteGameState() => gameState.data.difficulty,
          _ => Difficulty.medium,
        };

        final gameData = switch (gameState) {
          RunningGameState() => gameState.data,
          PausedGameState() => gameState.data,
          LastInvalidGameState() => gameState.data,
          WonGameState() => gameState.data,
          GameOverGameState() => gameState.data,
          MovingGameState() => gameState.data,
          ErrorMovingGameState() => gameState.data,
          AddingNoteGameState() => gameState.data,
          ErrorAddingNoteGameState() => gameState.data,
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
                leading: const Icon(Icons.calculate, color: Colors.redAccent),
                changeMode:
                    (mode) => context.read<ThemeCubit>().changeMode(mode),
              ),
              body: Padding(
                padding: const EdgeInsets.all(K.pagesPadding),
                child: Column(
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
                            context.read<GameBloc>().start(
                              difficulty: value,
                              overrideCurrent: true,
                            );
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
                              overrideCurrent: true,
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
                    BlocBuilder<NotesModeCubit, NotesModeState>(
                      builder: (context, notesModeState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 6,
                                bottom: 24,
                              ),
                              child: KeyboardNumbers(
                                // TODO refactor in una funzione che ritorna Function(int)?
                                onNumberTap:
                                    activeCellIndexes?.quadrant != null &&
                                            activeCellIndexes?.index != null &&
                                            gameData != null
                                        ? notesModeState.enabled
                                            ? (value) {
                                              context.read<GameBloc>().addNote(
                                                data: gameData,
                                                quadrant:
                                                    activeCellIndexes!
                                                        .quadrant!,
                                                index: activeCellIndexes.index!,
                                                value: value,
                                              );
                                            }
                                            : (value) {
                                              context.read<GameBloc>().move(
                                                data: gameData,
                                                quadrant:
                                                    activeCellIndexes!
                                                        .quadrant!,
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
                                  onPressed: () {
                                    context.read<NotesModeCubit>().toggleMode();
                                  },
                                  style:
                                      notesModeState.enabled
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
                                        color:
                                            notesModeState.enabled
                                                ? Colors.white
                                                : null,
                                      ),
                                      Text(
                                        notesModeState.enabled
                                            ? context.t?.notesOn ?? 'NOTES_ON'
                                            : context.t?.notesOff ??
                                                'NOTES_OFF',
                                      ),
                                    ],
                                  ),
                                ),
                                OutlinedButton(
                                  onPressed:
                                      activeCellIndexes?.quadrant != null &&
                                              activeCellIndexes?.index !=
                                                  null &&
                                              gameData != null
                                          ? () {
                                            context.read<GameBloc>().move(
                                              data: gameData,
                                              quadrant:
                                                  activeCellIndexes!.quadrant!,
                                              index: activeCellIndexes.index!,
                                              value: 0,
                                            );
                                          }
                                          : null,
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
                        );
                      },
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
                      : null,
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
