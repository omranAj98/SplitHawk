import 'dart:io';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splithawk/src/core/error/error_messages.dart';
import 'package:splithawk/src/core/localization/l10n/app_localizations.dart';

class CustomError extends Equatable {
  final String code;
  final String message;
  final String plugin;

  const CustomError({this.code = '', this.message = '', this.plugin = ''});

  @override
  List<Object> get props => [code, message, plugin];

  @override
  bool get stringify => true;

  String getMessage(BuildContext context) {
    if (code.isNotEmpty) {
      return ErrorMessages.getLocalizedMessage(code, context, plugin);
    }
    return AppLocalizations.of(context)!.defaultErrorMessage;
  }

  void showErrorDialog(BuildContext context) {
    print('Error code: $code Plugin: $plugin, Message: $message');
    showDialog(
      context: context,
      builder: (context) {
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: Text(AppLocalizations.of(context)!.error),
            content: Text(getMessage(context)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppLocalizations.of(context)!.ok),
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.error),
            content: Text(getMessage(context)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppLocalizations.of(context)!.ok),
              ),
            ],
          );
        }
      },
    );
    print('dialogError code{$code},Plugin{$plugin}, Message{$message}');
  }

  CustomError copyWith({String? code, String? message, String? plugin}) {
    return CustomError(
      code: code ?? this.code,
      message: message ?? this.message,
      plugin: plugin ?? this.plugin,
    );
  }
}
