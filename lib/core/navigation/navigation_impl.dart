import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:bpg_retail/app/routes/router.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/utilities/dialog_utils.dart';
import 'package:bpg_retail/core/utilities/log_utils.dart';
import 'package:bpg_retail/core/utilities/snackbar_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:bpg_retail/core/widgets/toast/toast.dart';
import 'navigator.dart';

@LazySingleton(as: AppNavigator)
class AppNavigatorImpl extends AppNavigator {
  AppNavigatorImpl(this._appRouter);

  TabsRouter? tabsRouter;

  final AppRouter _appRouter;

  StackRouter? get _currentTabRouter =>
      tabsRouter?.stackRouterOfIndex(currentBottomTab);

  StackRouter get _currentTabRouterOrRootRouter =>
      _currentTabRouter ?? _appRouter;

  m.BuildContext get _rootRouterContext =>
      _appRouter.navigatorKey.currentContext!;

  @override
  m.BuildContext get context => _rootRouterContext;

  m.BuildContext? get _currentTabRouterContext =>
      _currentTabRouter?.navigatorKey.currentContext;

  m.BuildContext get _currentTabContextOrRootContext =>
      _currentTabRouterContext ?? _rootRouterContext;

  @override
  int get currentBottomTab {
    if (tabsRouter == null) {
      throw 'Not found any TabRouter';
    }

    return tabsRouter?.activeIndex ?? 0;
  }

  @override
  bool get canPopSelfOrChildren => _appRouter.canPop();

  @override
  String getCurrentRouteName({bool useRootNavigator = false}) =>
      AutoRouter.of(
        useRootNavigator ? _rootRouterContext : _currentTabContextOrRootContext,
      ).current.name;

  @override
  void popUntilRootOfCurrentBottomTab() {
    if (tabsRouter == null) {
      throw 'Not found any TabRouter';
    }
    if (_currentTabRouter?.canPop() == true) {
      if (kDebugMode) {
        LogUtils.e('popUntilRootOfCurrentBottomTab');
      }
      _currentTabRouter?.popUntilRoot();
    }
  }

  @override
  void navigateToBottomTab(int index, {bool notify = true}) {
    if (tabsRouter == null) {
      throw 'Not found any TabRouter';
    }
    if (kDebugMode) {
      LogUtils.e('navigateToBottomTab with index = $index, notify = $notify');
    }
    tabsRouter?.setActiveIndex(index, notify: notify);
  }

  @override
  Future<T?> push<T extends Object?>(PageRouteInfo routeInfo) {
    if (kDebugMode) {
      LogUtils.e('push $routeInfo');
    }
    return _appRouter.push<T>(routeInfo);
  }

  @override
  Future<void> pushAll(List<PageRouteInfo> listAppRoute) {
    if (kDebugMode) {
      LogUtils.e('pushAll $listAppRoute');
    }
    return _appRouter.pushAll(listAppRoute);
  }

  @override
  Future<T?> replace<T extends Object?>(PageRouteInfo routeInfo) {
    if (kDebugMode) {
      LogUtils.e('replace by $routeInfo');
    }
    return _appRouter.replace<T>(routeInfo);
  }

  @override
  Future<void> replaceAll(List<PageRouteInfo> listAppRoute) {
    if (kDebugMode) {
      LogUtils.e('replaceAll by $listAppRoute');
    }
    return _appRouter.replaceAll(listAppRoute);
  }

  @override
  Future<bool> pop<T extends Object?>({
    T? result,
    bool useRootNavigator = false,
  }) {
    if (kDebugMode) {
      LogUtils.e('pop with result = $result, useRootNav = $useRootNavigator');
    }
    return useRootNavigator
        ? _appRouter.pop<T>(result)
        : _currentTabRouterOrRootRouter.pop<T>(result);
  }

  @override
  Future<T?> popAndPush<T extends Object?, R extends Object?>(
    PageRouteInfo pageRouteInfo, {
    R? result,
    bool useRootNavigator = false,
  }) {
    if (kDebugMode) {
      LogUtils.e(
        'popAndPush $pageRouteInfo with result = $result, useRootNav = $useRootNavigator',
      );
    }
    return useRootNavigator
        ? _appRouter.popAndPush<T, R>(pageRouteInfo, result: result)
        : _currentTabRouterOrRootRouter.popAndPush<T, R>(
          pageRouteInfo,
          result: result,
        );
  }

  @override
  void popUntilRoot({bool useRootNavigator = false}) {
    if (kDebugMode) {
      LogUtils.e('popUntilRoot, useRootNav = $useRootNavigator');
    }
    useRootNavigator
        ? _appRouter.popUntilRoot()
        : _currentTabRouterOrRootRouter.popUntilRoot();
  }

  @override
  void popUntilRouteName(String routeName) {
    if (kDebugMode) {
      LogUtils.e('popUntilRouteName $routeName');
    }
    _appRouter.popUntilRouteWithName(routeName);
  }

  @override
  bool removeUntilRouteName(String routeName) {
    if (kDebugMode) {
      LogUtils.e('removeUntilRouteName $routeName');
    }
    return _appRouter.removeUntil((route) => route.name == routeName);
  }

  @override
  bool removeAllRoutesWithName(String routeName) {
    if (kDebugMode) {
      LogUtils.e('removeAllRoutesWithName $routeName');
    }

    return _appRouter.removeWhere((route) => route.name == routeName);
  }

  @override
  Future<void> popAndPushAll(
    List<PageRouteInfo> listAppRoute, {
    bool useRootNavigator = false,
  }) {
    if (kDebugMode) {
      LogUtils.e('popAndPushAll $listAppRoute, useRootNav = $useRootNavigator');
    }

    return useRootNavigator
        ? _appRouter.popAndPushAll(listAppRoute)
        : _currentTabRouterOrRootRouter.popAndPushAll(listAppRoute);
  }

  @override
  bool removeLast() {
    if (kDebugMode) {
      LogUtils.e('removeLast');
    }
    return _appRouter.removeLast();
  }

  @override
  void back<T extends Object?>({T? result}) {
    m.Navigator.of(_rootRouterContext).pop(result);
  }

  @override
  void popUntilRoutePath(String routeName) {
    if (kDebugMode) {
      LogUtils.e('popUntilRouteName $routeName');
    }
    _appRouter.popUntilRouteWithPath(routeName);
  }

  @override
  void showErrorSnackBar(String message, {Duration? duration}) {
    SnackBarUtils.showAppSnackBar(
      _rootRouterContext,
      message,
      duration: duration,
      backgroundColor: AppColors.red_1,
    );
  }

  @override
  void showAppTopSnackBar(String message, {String? type}) {
    SnackBarUtils.showApTopSnackBar(_rootRouterContext, message, type: type);
  }

  @override
  void showSuccessSnackBar(String message, {Duration? duration}) {
    SnackBarUtils.showAppSnackBar(
      _rootRouterContext,
      message,
      duration: duration,
      backgroundColor: AppColors.main,
    );
  }

  @override
  void showToast(
    String text, {
    double? toastBorderRadius,
    Color? backgroundColor,
    Border? border,
    TextStyle? textStyle,
    int? toastDuration,
    Widget? trailing,
  }) {
    Toast.showToast(
      text,
      _rootRouterContext,
      toastBorderRadius: toastBorderRadius ?? 20.0,
      backgroundColor: backgroundColor ?? const Color(0xAA000000),
      border: border,
      textStyle:
          textStyle ?? const TextStyle(fontSize: 15, color: Colors.white),
      toastDuration: toastDuration,
      trailing: trailing,
    );
  }

  @override
  FutureOr showErrorDialog(String message, {Duration? duration}) {
    return DialogUtils.showErrorDialog(_rootRouterContext, content: message);
  }

  @override
  FutureOr showLoadingDialog(String message) {
    return DialogUtils.showLoadingDialog(_rootRouterContext, message: message);
  }

  @override
  FutureOr showSuccessDialog({
    required String content,
    m.VoidCallback? accept,
    m.VoidCallback? extraAccept,
    String? title,
    String? mainTitle,
    String? extraTitle,
    bool hasButton = true,
    bool hasButtonBack = true,
    Widget? icon,
  }) {
    return DialogUtils.showSuccessDialog(
      _rootRouterContext,
      content: content,
      accept: accept,
      title: title,
      extraAccept: extraAccept,
      extraTitle: extraTitle,
      mainTitle: mainTitle,
      hasButton: hasButton,
      hasButtonBack: hasButtonBack,
      icon: icon,
    );
  }

  @override
  Future showBottomSheet({
    required m.Widget child,
    Color? backgroundColor,
    bool enableDrag = false,
  }) {
    return showModalBottomSheet(
      context: _rootRouterContext,
      enableDrag: enableDrag,
      isScrollControlled: true,
      backgroundColor: backgroundColor ?? AppColors.white,
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(_rootRouterContext).viewInsets.bottom,
            ),
            child: child,
          ),
    );
  }

  @override
  FutureOr showWarningDialog(
    String message, {
    Duration? duration,
    String? actionTitle,
    VoidCallback? action,
  }) {
    return DialogUtils.showWarningDialog(
      _rootRouterContext,
      content: message,
      mainTap: action,
      mainTitle: actionTitle,
    );
  }
}
