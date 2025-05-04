import 'package:flutter/material.dart';
import 'package:splithawk/src/core/localization/l10n/app_localizations.dart';

class ErrorMessages {
  static String getLocalizedMessage(
    String code,
    BuildContext context,
    final String plugin,
  ) {
    switch (plugin) {
      case 'firebase_auth':
        switch (code) {
          case 'email-already-in-use':
            return AppLocalizations.of(context)!.emailAlreadyInUse;
          case 'user-not-found':
            return AppLocalizations.of(context)!.userNotFound;
          case 'network-request-failed':
            return AppLocalizations.of(context)!.networkError;
          case 'too-many-requests':
            return AppLocalizations.of(context)!.tooManyRequests;
          case 'invalid-credentials':
          case 'wrong-password':
            return AppLocalizations.of(context)!.invalidCredentials;
          default:
            return AppLocalizations.of(context)!.defaultErrorMessage;
        }
      case 'firebase_firestore':
        switch (code) {
          case 'permission-denied':
            return AppLocalizations.of(context)!.permissionDenied;
          case 'not-found':
            return AppLocalizations.of(context)!.notFound;
          case 'unavailable':
            return AppLocalizations.of(context)!.serviceUnavailable;
          default:
            return AppLocalizations.of(context)!.defaultErrorMessage;
        }
      case 'google_sign_in':
        switch (code) {
          case 'sign_in_failed':
            return AppLocalizations.of(context)!.signInFailed;
          case 'sign_in_canceled':
          default:
            return AppLocalizations.of(context)!.signInCanceled;
        }
      default:
        return AppLocalizations.of(context)!.defaultErrorMessage;
    }
  }
}
