import 'package:flutter/material.dart';

class KeyboardNumbers extends StatelessWidget {
  const KeyboardNumbers({required this.onNumberTap, super.key});

  final void Function(int)? onNumberTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Row(
        children: List.generate(
          9,
          (index) => Expanded(
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: InkWell(
                onTap:
                    onNumberTap != null ? () => onNumberTap!(index + 1) : null,
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface.withAlpha(
                        onNumberTap == null ? 75 : 255,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
