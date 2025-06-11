
import 'package:flutter/material.dart';

enum SnackBarType { success, error }

class AppSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    required SnackBarType type,
    Duration duration = const Duration(seconds: 3),
  }) {
    final backgroundColor = switch (type) {
      SnackBarType.success => Theme.of(context).colorScheme.primary,
      SnackBarType.error => Theme.of(context).colorScheme.error,
    };

    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      backgroundColor: backgroundColor,
      duration: duration,

      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
