import 'package:flutter/material.dart';
import 'package:sudoku/extensions/localized_context.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const Icon(Icons.calculate),
      title: Text(context.t?.appName ?? 'APP_NAME'),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
