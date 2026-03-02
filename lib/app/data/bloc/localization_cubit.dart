import 'package:tasa/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class LocalizationCubit extends Cubit<Locale> {
  LocalizationCubit() : super(const Locale('vi')) {
    final saveLanguage = preferences.language;
    if (saveLanguage != null && saveLanguage != state.languageCode) {
      emit(Locale(saveLanguage));
    }
  }
  final preferences = getIt<Preferences>();

  void changeLanguage(String languageCode) {
    emit(Locale(languageCode));
    preferences.saveLanguage(languageCode);
  }
}
