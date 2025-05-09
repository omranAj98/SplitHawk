import 'package:flutter/material.dart';

class AppSafeArea extends StatelessWidget {
  final Widget child;
  const AppSafeArea({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: child,
    );
  }
}
