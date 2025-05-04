import 'package:flutter/material.dart';

class AppSafeArea extends StatelessWidget {
  final Widget child;
  const AppSafeArea({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      child: child,
    );
  }
}
