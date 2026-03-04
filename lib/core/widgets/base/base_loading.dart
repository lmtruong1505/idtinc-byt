import 'package:tasa/core/constants/colors.dart';
import 'package:tasa/core/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

/// A reusable loading widget with customizable color, size, and height.
///
/// Usage:
/// - Inline: `const BaseLoading()`
/// - Custom size: `BaseLoading(size: 48)`
/// - Full height container: `BaseLoading(height: 200)`
class BaseLoading extends StatelessWidget {
  const BaseLoading({super.key, this.color, this.size, this.height});

  /// Color of the loading animation. Defaults to [AppColors.brand].
  final Color? color;

  /// Size of the loading dots. Defaults to [sp32] (32).
  final double? size;

  /// Optional container height wrapping the loading indicator.
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: LoadingAnimationWidget.hexagonDots(
          color: color ?? AppColors.main,
          size: size ?? sp32,
        ),
      ),
    );
  }
}
