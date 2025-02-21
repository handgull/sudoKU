import 'package:flutter/material.dart';
import 'package:sudoku/extensions/localized_context.dart';

enum Difficulty {
  beginner(18),
  easy(27),
  medium(36),
  hard(54);

  const Difficulty(this.value);

  final int value;
  String? localize(BuildContext context) {
    switch (this) {
      case Difficulty.beginner:
        return '🟢 ${context.t?.beginner}';
      case Difficulty.easy:
        return '🟡 ${context.t?.easy}';
      case Difficulty.medium:
        return '🟠 ${context.t?.medium}';
      case Difficulty.hard:
        return '🔴 ${context.t?.hard}';
    }
  }
}

class DifficultyDropdown extends StatelessWidget {
  const DifficultyDropdown({
    required this.onDifficultyChanged,
    required this.activeDifficulty,
    super.key,
  });

  final Difficulty activeDifficulty;
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
