import 'package:flutter/material.dart';
import 'package:splithawk/src/core/localization/l10n/app_localizations.dart';

void dialogQRCode(BuildContext context) {
  showDialog(
    context: context,
    builder:
        (context) => Center(
          child: AlertDialog(
            title: Text(AppLocalizations.of(context)!.yourQrCode),
            content: Image.asset("assets/images/qr-code.png"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context)!.close),
              ),
              TextButton(
                onPressed: () {},
                child: Text(AppLocalizations.of(context)!.shareQrCode),
              ),
            ],
          ),
        ),
  );
}
