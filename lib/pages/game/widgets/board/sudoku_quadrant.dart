import 'package:flutter/material.dart';
import 'package:sudoku/models/sudoku_cell/sudoku_cell.dart';
import 'package:sudoku/pages/game/widgets/board/sudoku_cell.dart';

class SudokuQuadrant extends StatelessWidget {
  const SudokuQuadrant({
    required this.subGrid,
    required this.onQuadrantTap,
    required this.errorState,
    super.key,
    this.active = false,
    this.activeQuadrantIndex,
  });

  final List<SudokuCell> subGrid;
  final bool active;
  final int? activeQuadrantIndex;
  final void Function(int) onQuadrantTap;
  final bool errorState;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(),
      child: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(4),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 3,
          mainAxisSpacing: 3,
        ),
        itemCount: subGrid.length,
        itemBuilder: (context, index) => SudokuQuadrantCell(
          cell: subGrid[index],
          onCellTap: () => onQuadrantTap(index),
          active: active && activeQuadrantIndex == index,
          errorState: errorState,
        ),
      ),
    );
  }
}
