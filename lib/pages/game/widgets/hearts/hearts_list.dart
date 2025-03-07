import 'package:flutter/material.dart';
import 'package:sudoku/misc/constants.dart';

class HeartsList extends StatelessWidget {
  const HeartsList({required this.hearts, super.key});

  final int hearts;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < K.maxHearts; i++) _Heart(filled: i < hearts),
      ],
    );
  }
}

class _Heart extends StatelessWidget {
  const _Heart({required this.filled, super.key});

  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Text(
      filled ? '❤️' : '🩶',
      style: const TextStyle(fontSize: 16),
    );
  }
}
