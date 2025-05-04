import 'package:flutter/material.dart';

BoxDecoration shimmerBoxDecoration(ColorScheme colorScheme) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(6.0),
    color: colorScheme.primary.withValues(alpha: 0.8),
  );
}
