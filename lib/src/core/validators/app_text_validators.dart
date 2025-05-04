import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:splithawk/src/core/localization/l10n/app_localizations.dart';

class AppTextValidators {
  static String? validateEmail(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.enterYourEmail;
    } else if (!isEmail(value.trim())) {
      return AppLocalizations.of(context)!.invalidEmail;
    }
    // Add more complex email validation if needed
    return null;
  }

  static String? validateEmpty(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.cantBeEmpty;
    }
    // Add more complex email validation if needed
    return null;
  }

  static String? validatePassword(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.enterYourPassword;
    } else if (value.trim().length < 7) {
      return AppLocalizations.of(context)!.passwordLength;
    } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return AppLocalizations.of(context)!.mustContainUppercase;
    } else if (!RegExp(r'[a-z]').hasMatch(value)) {
      return AppLocalizations.of(context)!.mustContainLowercase;
    } else if (!RegExp(r'[0-9]').hasMatch(value)) {
      return AppLocalizations.of(context)!.mustContainNumber;
    } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return AppLocalizations.of(context)!.mustContainSpecialChar;
    }

    return null;
  }

  static String? validateFullName(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.enterYourName;
    } else if (value.trim().length < 3) {
      return AppLocalizations.of(context)!.fullNameLength;
    }
    return null;
  }

  static String? validatePhoneNumber(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.enterYourPhoneNumber;
    } else {
      // Regular expression to match phone numbers starting with '+' or '00' followed by digits
      // and having more than 7 digits after the country code
      RegExp regExp = RegExp(r'^(?:\+|00)\d{7,}$');

      if (!regExp.hasMatch(value)) {
        return AppLocalizations.of(context)!.invalidPhoneNumber;
      }
    }
    return null; // Return null if validation succeeds
  }
}
