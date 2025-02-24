import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sudoku/extensions/localized_context.dart';
import 'package:sudoku/misc/sudoku_cell_operations.dart';
import 'package:sudoku/mixins/vibration_mixin.dart';
import 'package:sudoku/models/sudoku_cell/sudoku_cell.dart';
import 'package:sudoku/widgets/confetti.dart';

enum BoardStatus { running, paused, lost, won }

class Board extends StatelessWidget {
  const Board({
    required this.board,
    required this.onCellTap,
    required this.restart,
    required this.errorState,
    this.activeQuadrant,
    this.activeQuadrantIndex,
    this.status = BoardStatus.running,
    super.key,
  });

  final List<List<SudokuCell>>? board;
  final BoardStatus status;
  final int? activeQuadrant;
  final int? activeQuadrantIndex;
  final void Function(int, int) onCellTap;
  final void Function() restart;
  final bool errorState;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge, // Forced because of the border radius
      color: Theme.of(context).dividerTheme.color,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          AbsorbPointer(
            absorbing: status != BoardStatus.running,
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
              itemBuilder: (context, index) => _SudokuQuadrant(
                subGrid: _genQuadrant(board, index),
                onQuadrantTap: (cellIndex) => onCellTap(index, cellIndex),
                active:
                    status == BoardStatus.running && activeQuadrant == index,
                activeQuadrantIndex: activeQuadrantIndex,
                errorState: errorState,
              ),
            ),
          ),
          if (board == null) const CircularProgressIndicator(),
          if (status == BoardStatus.paused)
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
            )
          else if (status == BoardStatus.won)
            const Confetti(),
        ],
      ),
    );
  }

  List<SudokuCell> _genQuadrant(
    List<List<SudokuCell>>? board,
    int quadrantIndex,
  ) {
    if (board == null || board.isEmpty) {
      return List.generate(9, (_) => const SudokuCell(value: 0));
    } else {
      return List.generate(9, (cellIndex) {
        final row = findCellRow(quadrantIndex, cellIndex);
        final col = findCellCol(quadrantIndex, cellIndex);

        return board[row][col];
      });
    }
  }
}

class _SudokuQuadrant extends StatelessWidget {
  const _SudokuQuadrant({
    required this.subGrid,
    required this.onQuadrantTap,
    required this.errorState,
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
        itemBuilder: (context, index) => _SudokuQuadrantCell(
          cell: subGrid[index],
          onCellTap: () => onQuadrantTap(index),
          active: active && activeQuadrantIndex == index,
          errorState: errorState,
        ),
      ),
    );
  }
}

class _SudokuQuadrantCell extends StatelessWidget with VibrationMixin {
  const _SudokuQuadrantCell({
    required this.cell,
    required this.onCellTap,
    required this.errorState,
    this.active = false,
  });

  final SudokuCell cell;
  final bool active;
  final VoidCallback onCellTap;
  final bool errorState;

  Color? _findCellTextColor(
    BuildContext context,
    SudokuCell cell,
    bool errorState,
  ) {
    if (cell.invalidValue && errorState) {
      return Colors.red;
    } else if (!cell.editable) {
      return Theme.of(context).colorScheme.primary;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _verifyCell(cell),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(4),
          boxShadow: active
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
                    color: _findCellTextColor(context, cell, errorState),
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
                    return FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(1),
                        child: Text(
                          cell.notes.contains(noteValue)
                              ? noteValue.toString()
                              : '',
                        ),
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
