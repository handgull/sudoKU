import 'package:flutter/material.dart';
import 'package:sudoku/mixins/vibration_mixin.dart';
import 'package:sudoku/models/sudoku_cell/sudoku_cell.dart';

class SudokuQuadrantCell extends StatelessWidget with VibrationMixin {
  const SudokuQuadrantCell({
    required this.cell,
    required this.onCellTap,
    required this.errorState,
    super.key,
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
                      child: Text(
                        cell.notes.contains(noteValue)
                            ? noteValue.toString()
                            : '',
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
