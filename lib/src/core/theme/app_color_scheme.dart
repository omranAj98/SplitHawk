import 'package:flutter/material.dart';
import 'package:splithawk/src/core/constants/app_colors.dart';

class AppColorScheme {
  
  static ColorScheme get lightScheme => const ColorScheme(
        primary: AppColors.green,
        onPrimary: AppColors.white,
        secondary: AppColors.yellow,
        onSecondary: AppColors.black,
        surface: AppColors.subtleGrey,
        onSurface: AppColors.black,
        error: Colors.red,
        onError: AppColors.white,
        brightness: Brightness.light,
      );

  static ColorScheme get darkScheme => ColorScheme(
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
}
