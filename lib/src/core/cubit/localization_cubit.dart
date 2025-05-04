import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:flutter/material.dart';

class LocalizationCubit extends HydratedCubit<Locale> {
  LocalizationCubit({required this.systemLocale}) : super(systemLocale);

  final Locale systemLocale;

  void changeLocale(Locale locale) => emit(locale);

  @override
  Locale fromJson(Map<String, dynamic> json) {
    final code = json['languageCode'] as String?;
    return code != null ? Locale(code) : systemLocale;
  }

  @override
  Map<String, dynamic> toJson(Locale state) {
    return {'languageCode': state.languageCode};
  }
}
