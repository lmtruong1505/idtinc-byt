import 'package:tasa/core/constants/colors.dart';
import 'package:tasa/core/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SnackBarUtils {
  const SnackBarUtils._();

  static void showAppSnackBar(
    BuildContext context,
    String message, {
    Duration? duration,
    Color? backgroundColor,
  }) {
    final messengerState = ScaffoldMessenger.maybeOf(context);
    if (messengerState == null) {
      return;
    }
    messengerState.hideCurrentSnackBar();
    messengerState.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 10),
        backgroundColor: backgroundColor,
      ),
    );
  }

  static void showApTopSnackBar(
    BuildContext context,
    String message, {
    String? type = 'info',
  }) {
    var snackBar = CustomSnackBar.info(
      message: message,
      icon: const SizedBox.shrink(),
      textStyle: AppTypography.p5.copyWith(color: AppColors.white),
      textAlign: TextAlign.start,
      borderRadius: BorderRadius.zero,
    );
    if (type == 'error') {
      snackBar = CustomSnackBar.error(
        message: message,
        icon: const SizedBox.shrink(),
        textStyle: AppTypography.p5.copyWith(color: AppColors.white),
        textAlign: TextAlign.start,
        borderRadius: BorderRadius.zero,
      );
    } else if (type == 'success') {
      snackBar = CustomSnackBar.success(
        message: message,
        icon: const SizedBox.shrink(),
        textStyle: AppTypography.p5.copyWith(color: AppColors.white),
        textAlign: TextAlign.start,
        borderRadius: BorderRadius.zero,
      );
    }

    showTopSnackBar(
      Overlay.of(context),
      snackBar,
      padding: EdgeInsets.zero,
      curve: Curves.linear,
      animationDuration: const Duration(milliseconds: 400),
    );
  }
}
