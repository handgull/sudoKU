import 'package:flutter/material.dart';
import 'package:sudoku/extensions/localized_context.dart';

// This is a dummy widget so i have decided to use callbacks.
// This is decoupling, if i leave bloc i do not need to edit the widget
class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({required this.changeMode, this.leading, super.key});

  final Widget? leading;
  final void Function(ThemeMode? mode) changeMode;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return AppBar(
      leading: leading,
      title: Text(
        context.t?.appName ?? 'APP_NAME',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => toggleTheme(brightness),
          icon: const _ToggleIcon(),
          tooltip:
              brightness == Brightness.light
                  ? context.t?.darkTheme
                  : context.t?.lightTheme,
        ),
      ],
    );
  }

  void toggleTheme(Brightness brightness) {
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
