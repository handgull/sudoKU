import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sudoku/extensions/localized_context.dart';
import 'package:sudoku/mixins/vibration_mixin.dart';
import 'package:sudoku/models/sudoku_cell/sudoku_cell.dart';

class Board extends StatelessWidget {
  const Board({
    required this.board,
    required this.onCellTap,
    required this.restart,
    this.activeQuadrant,
    this.activeQuadrantIndex,
    this.paused = false,
    super.key,
  });

  final List<List<SudokuCell>>? board;
  final bool paused;
  final int? activeQuadrant;
  final int? activeQuadrantIndex;
  final void Function(int, int) onCellTap;
  final void Function() restart;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).dividerTheme.color ?? Colors.transparent,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          AbsorbPointer(
            absorbing: paused,
            child: GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
              ),
              itemCount: (board?.isNotEmpty ?? false) ? board?.length : 9,
              itemBuilder:
                  (context, index) => _SudokuQuadrant(
                    subGrid:
                        board != null && board!.isNotEmpty
                            ? board![index]
                            : List.generate(
                              9,
                              (_) => const SudokuCell(value: 0),
                            ),
                    onQuadrantTap:
                        (quadrantIndex) => onCellTap(index, quadrantIndex),
                    active: activeQuadrant == index,
                    activeQuadrantIndex: activeQuadrantIndex,
                  ),
            ),
          ),
          if (board == null) const CircularProgressIndicator(),
          if (paused)
            Positioned.fill(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).cardColor,
                      ),
                      child: Center(
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          tooltip: context.t?.resume,
                          iconSize: 100,
                          icon: Icon(
                            Icons.play_circle,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: restart,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SudokuQuadrant extends StatelessWidget {
  const _SudokuQuadrant({
    required this.subGrid,
    required this.onQuadrantTap,
    this.active = false,
    this.activeQuadrantIndex,
  });

  final List<SudokuCell> subGrid;
  final bool active;
  final int? activeQuadrantIndex;
  final void Function(int) onQuadrantTap;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).cardColor,
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
        itemBuilder:
            (context, index) => _SudokuQuadrantCell(
              cell: subGrid[index],
              onCellTap: () => onQuadrantTap(index),
              active: active && activeQuadrantIndex == index,
            ),
      ),
    );
  }
}

class _SudokuQuadrantCell extends StatelessWidget with VibrationMixin {
  const _SudokuQuadrantCell({
    required this.cell,
    required this.onCellTap,
    this.active = false,
  });

  final SudokuCell cell;
  final bool active;
  final VoidCallback onCellTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _verifyCell(cell),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(4),
          boxShadow:
              active
                  ? [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary,
                      blurRadius: 4,
                    ),
                    BoxShadow(
                      color: Theme.of(context).primaryColor,
                      blurRadius: 2,
                    ),
                  ]
                  : null,
        ),
        child: Stack(
          children: [
            if (cell.value != 0)
              Center(
                child: Text(
                  cell.value.toString(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight:
                        cell.editable ? FontWeight.normal : FontWeight.bold,
                    color:
                        cell.editable
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            if (cell.value == 0 && cell.notes.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(2),
                child: GridView.count(
                  crossAxisCount: 3,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(9, (index) {
                    final noteValue = index + 1;
                    return Center(
                      child: Text(
                        cell.notes.contains(noteValue)
                            ? noteValue.toString()
                            : '',
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _verifyCell(SudokuCell cell) async {
    if (cell.editable) {
      onCellTap();
    } else {
      await vibrate();
    }
  }
}
