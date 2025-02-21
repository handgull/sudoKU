import 'package:flutter/material.dart';

class KeyboardNumbers extends StatelessWidget {
  const KeyboardNumbers({super.key});

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
                onTap: () => {},
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
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
