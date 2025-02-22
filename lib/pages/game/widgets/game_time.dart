import 'package:flutter/material.dart';

enum GameTimeStatus { waiting, lost, won }

class GameTime extends StatelessWidget {
  const GameTime({
    required this.seconds,
    this.status = GameTimeStatus.waiting,
    super.key,
  });

  final int? seconds;
  final GameTimeStatus status;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        _findTime(seconds),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          letterSpacing: 1,
          color: _findTextColor(status),
        ),
      ),
    );
  }

  String _findTime(int? seconds) {
    if (seconds == null) {
      return '--:--';
    }

    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');

    return '$minutes:$remainingSeconds';
  }

  Color? _findTextColor(GameTimeStatus status) {
    switch (status) {
      case GameTimeStatus.waiting:
        return null;
      case GameTimeStatus.lost:
        return Colors.red;
      case GameTimeStatus.won:
        return Colors.green;
    }
  }
}
