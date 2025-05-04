import 'package:flutter/material.dart';
import 'package:splithawk/src/core/enums/menus.dart';

class WdBottomNavigationItem extends StatelessWidget {
  final VoidCallback onPressed;
  final Menus name;
  final String? title;
  final IconData icon;
  final double? size;
  final Menus current;
  const WdBottomNavigationItem({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.name,
    required this.current,
    this.title,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            color:
                current == name ? colorScheme.surface : colorScheme.onSurface,
            size: size ?? 30,
            icon,
          ),
          if (title != null && title!.isNotEmpty)
            SizedBox(
              width: 60,
              child: Text(
                title!,
                style: TextStyle(color: colorScheme.surface, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
