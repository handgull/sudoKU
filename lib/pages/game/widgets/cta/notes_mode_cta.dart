import 'package:flutter/material.dart';
import 'package:sudoku/extensions/localized_context.dart';

class NotesModeCta extends StatelessWidget {
  const NotesModeCta({
    required this.toggleNotesMode,
    required this.enabled,
    super.key,
  });

  final VoidCallback toggleNotesMode;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: toggleNotesMode,
      style: enabled
          ? ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            )
          : null,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 3),
            child: Icon(
              Icons.edit_note,
              color: enabled ? Colors.white : null,
            ),
          ),
          Text(
            enabled
                ? context.t?.notesOn ?? 'NOTES_ON'
                : context.t?.notesOff ?? 'NOTES_OFF',
          ),
        ],
      ),
    );
  }
}
