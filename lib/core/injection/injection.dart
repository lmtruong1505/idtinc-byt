import 'package:tasa/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'injection.config.dart';

@module
abstract class Module {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 20.0
    ..indicatorColor = AppColors.white
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = AppColors.white
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = true
    ..maskType = EasyLoadingMaskType.black
    ..indicatorWidget = LoadingAnimationWidget.fourRotatingDots(
      color: AppColors.main,
      size: 32,
    );
}
