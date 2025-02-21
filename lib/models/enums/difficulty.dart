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
