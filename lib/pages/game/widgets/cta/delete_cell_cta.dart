import 'package:flutter/material.dart';
import 'package:sudoku/extensions/localized_context.dart';

class DeleteCellCta extends StatelessWidget {
  const DeleteCellCta({required this.delete, super.key});

  final VoidCallback? delete;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: delete,
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 3),
            child: Icon(Icons.edit_off),
          ),
          Text(context.t?.erase ?? 'ERASE'),
        ],
      ),
    );
  }
}
