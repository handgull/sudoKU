import 'package:flutter/material.dart';
import 'package:sudoku/models/enums/difficulty.dart';

class DifficultyDropdown extends StatelessWidget {
  const DifficultyDropdown({
    required this.onDifficultyChanged,
    required this.activeDifficulty,
    super.key,
  });

  final Difficulty? activeDifficulty;
  final void Function(Difficulty) onDifficultyChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Difficulty>(
      value: activeDifficulty,
      onChanged: (Difficulty? newValue) {
        if (newValue != null) {
          onDifficultyChanged(newValue);
        }
      },
      underline: const SizedBox(),
      items: Difficulty.values
          .map<DropdownMenuItem<Difficulty>>((entry) {
            return DropdownMenuItem<Difficulty>(
              value: entry,
              child: Text(
                entry.localize(context) ?? 'ENTRY_TEXT_${entry.value}',
              ),
            );
          })
          .toList(growable: false),
    );
  }
}
