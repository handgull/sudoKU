import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/cubits/theme/theme_cubit.dart';
import 'package:sudoku/extensions/localized_context.dart';
import 'package:sudoku/misc/constants.dart';
import 'package:sudoku/pages/game/widgets/difficulty_dropdown.dart';
import 'package:sudoku/pages/game/widgets/keyboard_numbers.dart';
import 'package:sudoku/routers/app_router.gr.dart';
import 'package:sudoku/widgets/main_app_bar.dart';

@RoutePage()
class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final noteMode = Random().nextBool(); // TODO allacciare logica
    final paused = Random().nextBool(); // TODO allacciare logica

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
                  onDifficultyChanged: (_) {},
                  activeDifficulty: Difficulty.medium, // TODO allacciare
                ),
                IconButton(
                  tooltip: context.t?.restart,
                  onPressed: () {},
                  icon: const Icon(Icons.restart_alt),
                ),
              ],
            ),
            const Expanded(child: Center()),
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
        child: paused ? const Icon(Icons.play_arrow) : const Icon(Icons.pause),
      ),
    );
  }
}
