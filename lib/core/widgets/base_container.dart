import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:tasa/core/constants/colors.dart';

class BaseContainer extends StatelessWidget {
  const BaseContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius,
    this.padding,
    this.color,
    this.borderColor,
    this.borderWidth,
    this.margin,
    this.boxShadow,
    this.isCircle = false,
    this.isDotted = false,
    this.dashPattern,
  });

  final Widget child;
  final double? width;
  final double? height;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Color? borderColor;
  final double? borderWidth;
  final List<BoxShadow>? boxShadow;
  final bool isCircle;
  final bool isDotted;
  final List<double>? dashPattern;

  @override
  Widget build(BuildContext context) {
    if (isDotted) {
      return Container(
        margin: margin,
        child: DottedBorder(
          padding: EdgeInsets.zero,
          borderType: isCircle ? BorderType.Circle : BorderType.RRect,
          radius: Radius.circular(borderRadius ?? 8),
          color: borderColor ?? AppColors.black,
          strokeWidth: borderWidth ?? 1,
          dashPattern: dashPattern ?? [6, 3],
          child: Container(
            width: width,
            height: height,
            padding: padding,
            decoration: BoxDecoration(
              color: color ?? AppColors.white,
              shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
              borderRadius:
                  isCircle ? null : BorderRadius.circular(borderRadius ?? 8),
            ),
            child: child,
          ),
        ),
      );
    }
    return Container(
      margin: margin,
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius:
            isCircle ? null : BorderRadius.circular(borderRadius ?? 8),
        border:
            borderColor != null
                ? Border.all(color: borderColor!, width: borderWidth ?? 1)
                : null,
        color: color ?? AppColors.white,
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }
}
