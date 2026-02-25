import 'package:bpg_retail/core/constants/colors.dart';
import 'package:flutter/material.dart';

class BaseProgressBar extends StatelessWidget {
  final double value; // 0.0 to 100.0
  final double height;
  final Color? backgroundColor;
  final Color? progressColor;

  const BaseProgressBar({
    super.key,
    required this.value,
    this.height = 6,
    this.backgroundColor = AppColors.greyE2,
    this.progressColor,
  });

  Color _getColor(double value) {
    if (value <= 30) {
      return AppColors.green_1;
    } else if (value <= 60) {
      return AppColors.blue_1;
    } else if (value <= 80) {
      return AppColors.accent_5;
    } else {
      return AppColors.red_1;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure value is between 0 and 100
    final clampedValue = value.clamp(0.0, 100.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: clampedValue / 100,
        backgroundColor: backgroundColor,
        valueColor: AlwaysStoppedAnimation<Color>(
          progressColor ?? _getColor(clampedValue),
        ),
        minHeight: height,
      ),
    );
  }
}
