import 'package:flutter/material.dart';
import 'package:splithawk/src/core/constants/app_colors.dart';
import 'app_text_theme.dart';

class AppTheme {
  static ThemeData lightTheme() {
    const lightScheme = ColorScheme(
      primary: AppColors.green,
      onPrimary: AppColors.white,
      secondary: AppColors.yellow,
      onSecondary: AppColors.black,
      surface: AppColors.subtleGrey,
      onSurface: AppColors.darkBlack,
      error: Colors.red,
      onError: AppColors.white,
      brightness: Brightness.light,
    );

    return ThemeData(
      fontFamily: 'Poppins',
      colorScheme: lightScheme,
      primaryColor: lightScheme.primary,
      secondaryHeaderColor: lightScheme.secondary,
      textTheme: TextTheme(
        headlineLarge: AppTextTheme.h1.copyWith(color: lightScheme.onSurface),
        headlineMedium: AppTextTheme.h2.copyWith(color: lightScheme.onSurface),
        headlineSmall: AppTextTheme.h3.copyWith(color: lightScheme.onSurface),
        displayLarge: AppTextTheme.h4.copyWith(color: lightScheme.onSurface),
        displayMedium: AppTextTheme.h5.copyWith(color: lightScheme.onSurface),
        displaySmall: AppTextTheme.h6.copyWith(color: lightScheme.onSurface),
        bodyLarge: AppTextTheme.h7.copyWith(color: lightScheme.onSurface),
        bodyMedium: AppTextTheme.h8.copyWith(color: lightScheme.onSurface),
      ),
    );
  }

  static ThemeData darkTheme() {
    final darkScheme = ColorScheme(
      primary: AppColors.green,
      onPrimary: AppColors.black,
      secondary: AppColors.yellow,
      onSecondary: AppColors.white,
      surface: AppColors.darkBlack,
      onSurface: AppColors.white,
      error: Colors.red.shade400,
      onError: AppColors.black,
      brightness: Brightness.dark,
    );

    return ThemeData(
      fontFamily: 'Poppins',
      colorScheme: darkScheme,
      primaryColor: darkScheme.primary,
      secondaryHeaderColor: darkScheme.secondary,
      textTheme: TextTheme(
        headlineLarge: AppTextTheme.h1.copyWith(color: darkScheme.onSurface),
        headlineMedium: AppTextTheme.h2.copyWith(color: darkScheme.onPrimary),
        headlineSmall: AppTextTheme.h3.copyWith(color: darkScheme.onSurface),
        displayLarge: AppTextTheme.h4.copyWith(color: darkScheme.onSurface),
        displayMedium: AppTextTheme.h5.copyWith(color: darkScheme.onSurface),
        displaySmall: AppTextTheme.h6.copyWith(color: darkScheme.onSurface),
        bodyLarge: AppTextTheme.h7.copyWith(color: darkScheme.onSurface),
        bodyMedium: AppTextTheme.h8.copyWith(color: darkScheme.onSurface),
      ),
    );
  }
}
