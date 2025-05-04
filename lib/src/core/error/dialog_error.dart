import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:splithawk/src/core/error/custom_error.dart';
import 'package:splithawk/src/core/localization/l10n/app_localizations.dart';

void dialogError(BuildContext context, CustomError error) {
  print('dialogError: ${error.plugin} - ${error.message}');
  showDialog(
    context: context,
    builder: (context) {
      if (Platform.isIOS) {
        return CupertinoAlertDialog(
          title: Text('${AppLocalizations.of(context)!.error} : ${error.code}'),
          content: Text('${error.plugin}\n${error.message}'),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                context.pop();
              },
              child: Text(AppLocalizations.of(context)!.ok),
            ),
          ],
        );
      } else {
        return AlertDialog(
          title: Text('${AppLocalizations.of(context)!.error} : ${error.code}'),
          contentPadding: const EdgeInsets.all(16.0),
          content: Text('${error.plugin}\n${error.message}'),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: Text(AppLocalizations.of(context)!.ok),
            ),
          ],
        );
      }
    },
  );
}
