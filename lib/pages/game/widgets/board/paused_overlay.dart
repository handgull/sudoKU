import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sudoku/extensions/localized_context.dart';

class PausedOverlay extends StatelessWidget {
  const PausedOverlay({required this.restart, super.key});

  final void Function() restart;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
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
    );
  }
}
