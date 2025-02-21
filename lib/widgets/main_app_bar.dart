import 'package:flutter/material.dart';
import 'package:sudoku/extensions/localized_context.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({required this.changeMode, super.key});

  final void Function(ThemeMode? mode) changeMode;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const Icon(Icons.calculate, color: Colors.redAccent),
      title: Text(
        context.t?.appName ?? 'APP_NAME',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          onPressed: () => toggleTheme(context),
          icon: const _ToggleIcon(),
        ),
      ],
    );
  }

  void toggleTheme(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    changeMode(
      brightness == Brightness.light ? ThemeMode.dark : ThemeMode.light,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ToggleIcon extends StatelessWidget {
  const _ToggleIcon();

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Icon(
      brightness == Brightness.light ? Icons.mode_night : Icons.sunny,
    );
  }
}
