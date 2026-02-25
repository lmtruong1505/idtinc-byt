import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

abstract class AppNavigator {
  const AppNavigator();

  bool get canPopSelfOrChildren;

  int get currentBottomTab;

  BuildContext get context;

  String getCurrentRouteName({bool useRootNavigator = false});

  void popUntilRootOfCurrentBottomTab();

  void navigateToBottomTab(int index, {bool notify = true});

  Future<T?> push<T extends Object?>(PageRouteInfo routeInfo);

  Future<void> pushAll(List<PageRouteInfo> listAppRoute);

  Future<T?> replace<T extends Object?>(PageRouteInfo routeInfo);

  void back<T extends Object?>({T? result});

  Future<void> replaceAll(List<PageRouteInfo> listAppRoute);

  Future<bool> pop<T extends Object?>({
    T? result,
    bool useRootNavigator = false,
  });

  Future<T?> popAndPush<T extends Object?, R extends Object?>(
    PageRouteInfo pageRouteInfo, {
    R? result,
    bool useRootNavigator = false,
  });

  Future<void> popAndPushAll(
    List<PageRouteInfo> listAppRoute, {
    bool useRootNavigator = false,
  });

  void popUntilRoot({bool useRootNavigator = false});

  void popUntilRouteName(String routeName);

  void popUntilRoutePath(String routeName);

  bool removeUntilRouteName(String routeName);

  bool removeAllRoutesWithName(String routeName);

  bool removeLast();

  Future showBottomSheet({
    required Widget child,
    Color? backgroundColor,
    bool enableDrag,
  });

  void showErrorSnackBar(
    String message, {
    Duration? duration = const Duration(seconds: 1),
  });

  void showAppTopSnackBar(String message, {String? type});

  void showSuccessSnackBar(
    String message, {
    Duration? duration = const Duration(seconds: 1),
  });

  void showToast(
    String text, {
    double? toastBorderRadius,
    Color? backgroundColor,
    Border? border,
    TextStyle? textStyle,
    int? toastDuration,
    Widget? trailing,
  });

  FutureOr showSuccessDialog({
    required String content,
    VoidCallback? accept,
    VoidCallback? extraAccept,
    String? title,
    String? mainTitle,
    String? extraTitle,
    bool hasButton = true,
    bool hasButtonBack = true,
    Widget? icon,
  });

  FutureOr showWarningDialog(
    String message, {
    Duration? duration,
    String? actionTitle,
    VoidCallback? action,
  });

  FutureOr showErrorDialog(String message, {Duration? duration});

  FutureOr showLoadingDialog(String message);
}
