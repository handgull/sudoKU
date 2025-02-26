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
import 'package:sudoku/models/sudoku_data/sudoku_data.dart';
import 'package:sudoku/pages/game/widgets/board/board.dart';
import 'package:sudoku/pages/game/widgets/cta/delete_cell_cta.dart';
import 'package:sudoku/pages/game/widgets/cta/keyboard_numbers.dart';
import 'package:sudoku/pages/game/widgets/cta/notes_mode_cta.dart';
import 'package:sudoku/pages/game/widgets/difficulty_dropdown.dart';
import 'package:sudoku/pages/game/widgets/game_time.dart';
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
            create: (context) => GameBloc(
              gameRepository: context.read(),
              gameTimerRepository: context.read(),
            )..start(),
          ),
          BlocProvider(create: (context) => ActiveCellCubit()),
          BlocProvider(
            create: (context) =>
                GameTimerCubit(gameTimerRepository: context.read()),
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
      listener: (context, state) => switch (state) {
        ErrorStartingGameState() => _onErrorStarting(context),
        LastInvalidGameState() => vibrate(),
        _ => null,
      },
      builder: (context, gameState) {
        // Here i save the values because they will be reused across the page
        final activeDifficulty = findActiveDifficulty(gameState);
        final gameData = findGameData(gameState);
        final boardStatus = findBoardStatus(gameState);

        return BlocBuilder<ActiveCellCubit, ActiveCellState>(
          builder: (context, cellState) {
            final activeCellIndexes = switch (cellState) {
              ActiveActiveCellState() => cellState,
              _ => null,
            };

            return Scaffold(
              appBar: MainAppBar(
                leading: const Icon(Icons.calculate, color: Colors.redAccent),
                changeMode: (mode) =>
                    context.read<ThemeCubit>().changeMode(mode),
              ),
              body: Padding(
                padding: const EdgeInsets.only(
                  top: K.pagesPadding,
                  left: K.pagesPadding,
                  right: K.pagesPadding,
                  bottom: 72,
                ),
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
                          errorState: findLastInvalid(gameState),
                          activeQuadrant: activeCellIndexes?.quadrant,
                          activeQuadrantIndex: activeCellIndexes?.index,
                          onCellTap: (quadrant, index) => context
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
                            KeyboardNumbers(
                              onNumberTap: _onNumberTap(
                                context: context,
                                quadrant: activeCellIndexes?.quadrant,
                                index: activeCellIndexes?.index,
                                data: gameData,
                                boardStatus: boardStatus,
                                notesModeEnabled: notesModeState.enabled,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              floatingActionButton: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BlocBuilder<NotesModeCubit, NotesModeState>(
                    builder: (context, notesModeState) {
                      return Row(
                        children: [
                          NotesModeCta(
                            toggleNotesMode: () {
                              context.read<NotesModeCubit>().toggleMode();
                            },
                            enabled: notesModeState.enabled,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: DeleteCellCta(
                              delete: activeCellIndexes?.quadrant != null &&
                                      activeCellIndexes?.index != null &&
                                      gameData != null &&
                                      boardStatus == BoardStatus.running
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
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  if (gameData != null &&
                      (boardStatus != BoardStatus.won &&
                          boardStatus != BoardStatus.lost))
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: FloatingActionButton(
                        onPressed: () {
                          context.read<GameBloc>().togglePause(gameData);
                        },
                        tooltip: boardStatus == BoardStatus.paused
                            ? context.t?.resume
                            : context.t?.pause,
                        child: boardStatus == BoardStatus.paused
                            ? const Icon(Icons.play_arrow)
                            : const Icon(Icons.pause),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void Function(int)? _onNumberTap({
    required BuildContext context,
    required int? quadrant,
    required int? index,
    required SudokuData? data,
    required BoardStatus boardStatus,
    required bool notesModeEnabled,
  }) {
    return quadrant != null &&
            index != null &&
            data != null &&
            boardStatus == BoardStatus.running
        ? notesModeEnabled
            ? (value) {
                context.read<GameBloc>().addNote(
                      data: data,
                      quadrant: quadrant,
                      index: index,
                      value: value,
                    );
              }
            : (value) {
                context.read<GameBloc>().move(
                      data: data,
                      quadrant: quadrant,
                      index: index,
                      value: value,
                    );
              }
        : null;
  }

  void _onErrorStarting(BuildContext context) {
    showSnackbar(
      context,
      backgroundColor: Colors.red,
      message: Text(context.t?.errorStartingGame ?? 'ERROR_STARTING_GAME'),
    );
  }
}
