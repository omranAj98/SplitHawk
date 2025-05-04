import 'package:flutter/material.dart';
import 'package:splithawk/src/core/enums/menus.dart';
import 'package:splithawk/src/core/widgets/nav_bar/wd_bottom_navigation_item.dart';
import 'package:splithawk/src/core/localization/l10n/app_localizations.dart';

class WdBottomNavigationBar extends StatelessWidget {
  final Menus currentIndex;
  final ValueChanged<Menus> onTap;
  const WdBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: EdgeInsets.all(14),
      height: screenHeight * 0.1,
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(36),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          WdBottomNavigationItem(
            icon: Icons.home,
            onPressed: () => onTap(Menus.home),
            title: AppLocalizations.of(context)!.home,
            name: Menus.home,
            current: currentIndex,
          ),
          WdBottomNavigationItem(
            title: AppLocalizations.of(context)!.groups,
            icon: Icons.group,
            onPressed: () => onTap(Menus.group),
            name: Menus.group,
            current: currentIndex,
          ),
          WdBottomNavigationItem(
            icon: Icons.add_box,
            size: 60,
            onPressed: () => onTap(Menus.add),
            name: Menus.add,
            current: currentIndex,
          ),
          WdBottomNavigationItem(
            title: AppLocalizations.of(context)!.activities,
            icon: Icons.monitor_heart_rounded,
            onPressed: () => onTap(Menus.activity),
            name: Menus.activity,
            current: currentIndex,
          ),
          WdBottomNavigationItem(
            title: AppLocalizations.of(context)!.account,
            icon: Icons.account_circle_rounded,
            onPressed: () => onTap(Menus.account),
            name: Menus.account,
            current: currentIndex,
          ),
        ],
      ),
    );
  }
}
