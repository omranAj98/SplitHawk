import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({
    required this.isLoading,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child, 
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(
                alpha: 0.5,
              ), 
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}
