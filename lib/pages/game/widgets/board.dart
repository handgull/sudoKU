import 'package:flutter/material.dart';
import 'package:sudoku/models/sudoku_cell/sudoku_cell.dart';

class Board extends StatelessWidget {
  const Board({required this.board, super.key});

  final List<List<SudokuCell>>? board;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        ColoredBox(
          color: Theme.of(context).dividerTheme.color ?? Colors.transparent,
          child: AbsorbPointer(
            absorbing: false, // TODO collegare alla pausa
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
                  ),
            ),
          ),
        ),
        if (board == null) const CircularProgressIndicator(),
      ],
    );
  }
}

class _SudokuQuadrant extends StatelessWidget {
  const _SudokuQuadrant({required this.subGrid});
  final List<SudokuCell> subGrid;

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
            (context, index) => _SudokuQuadrantCell(cell: subGrid[index]),
      ),
    );
  }
}

class _SudokuQuadrantCell extends StatelessWidget {
  const _SudokuQuadrantCell({required this.cell});
  final SudokuCell cell;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {}, // TODO handle focus
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(4),
          // TODO agganciare shadow al focus
          boxShadow:
              false
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
}
