import 'package:flutter/material.dart';

BoxDecoration shimmerBoxDecoration(ColorScheme colorScheme) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(6.0),
    color: colorScheme.primary.withValues(alpha: 0.8),
    gradient: LinearGradient(
      colors: [
        colorScheme.primary.withAlpha(130),
        colorScheme.primary.withAlpha(40),
        colorScheme.primary.withAlpha(250),
      ],
      begin: Alignment.centerRight,
      end: Alignment.centerLeft,
      // end: Alignment.bottomRight,
      // stops: const [0.2, 0.5, 0.8],
    ),
  );
}
