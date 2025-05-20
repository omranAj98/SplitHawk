import 'package:flutter/material.dart';
import 'package:splithawk/src/core/error/custom_error.dart';
import 'package:splithawk/src/core/localization/l10n/app_localizations.dart';

class AppErrorSnackBar extends StatelessWidget {
  final CustomError? error;
  final BuildContext context;
  final Duration duration;

  const AppErrorSnackBar({
    super.key,
    this.error,
    required this.context,
    this.duration = const Duration(seconds: 4),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SnackBar(
      content: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.white, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              error == null
                  ? AppLocalizations.of(context)!.errorOccurred
                  : error!.getMessage(context),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              softWrap: true,
              textWidthBasis: TextWidthBasis.longestLine,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: theme.colorScheme.error,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.all(12),
      duration: duration,
      action: SnackBarAction(
        label: AppLocalizations.of(context)!.close,
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
      elevation: 6,
    );
  }
}
