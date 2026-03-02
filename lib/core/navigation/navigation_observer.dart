import 'package:tasa/core/utilities/log_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppNavigatorObserver extends NavigatorObserver {
  AppNavigatorObserver();

  static const _enableLog = kDebugMode;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (_enableLog) {
      LogUtils.e(
        'didPush from ${previousRoute?.settings.name} to ${route.settings.name}',
      );
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (_enableLog) {
      LogUtils.e(
        'didPop ${route.settings.name}, back to ${previousRoute?.settings.name}',
      );
    }
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    if (_enableLog) {
      LogUtils.e(
        'didRemove ${route.settings.name}, back to ${previousRoute?.settings.name}',
      );
    }
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (_enableLog) {
      LogUtils.e(
        'didReplace ${oldRoute?.settings.name} by ${newRoute?.settings.name}',
      );
    }
  }
}
