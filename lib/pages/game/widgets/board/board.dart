import 'package:flutter/material.dart';
import 'package:sudoku/misc/sudoku_cell_operations.dart';
import 'package:sudoku/models/sudoku_cell/sudoku_cell.dart';
import 'package:sudoku/pages/game/widgets/board/paused_overlay.dart';
import 'package:sudoku/pages/game/widgets/board/sudoku_quadrant.dart';
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
              itemBuilder: (context, index) => SudokuQuadrant(
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
            PausedOverlay(restart: restart)
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
