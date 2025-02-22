import 'package:flutter/material.dart';

mixin SnackbarMixin {
  void showSnackbar(
    BuildContext context, {
    required Widget message,
    String close = 'OK',
    EdgeInsets? margin,
    Duration duration = const Duration(seconds: 3),
    SnackBarBehavior behavior = SnackBarBehavior.fixed,
    Color? backgroundColor,
  }) {
    final snackBar = SnackBar(
      duration: duration,
      margin: margin,
      content: message,
      backgroundColor: backgroundColor,
      action: SnackBarAction(label: close, onPressed: () {}),
      behavior: behavior,
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void closeSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }
}
