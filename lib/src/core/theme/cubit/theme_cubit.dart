import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'theme_state.dart';

class ThemeCubit extends HydratedCubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(themeMode: ThemeMode.system));

  void toggleTheme(bool isDarkMode) {
    emit(ThemeState(themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light));
  }

  void setThemeMode(ThemeMode mode) {
    emit(ThemeState(themeMode: mode));
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    try {
      final themeMode = ThemeMode.values[json['themeMode'] as int];
      return ThemeState(themeMode: themeMode);
    } catch (_) {
      return const ThemeState(themeMode: ThemeMode.system);
    }
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    return {'themeMode': state.themeMode.index};
  }
}
