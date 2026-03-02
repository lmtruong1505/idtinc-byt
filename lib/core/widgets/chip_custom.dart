import 'package:tasa/core/configs/app_style/init_app_style.dart';
import 'package:tasa/core/core.dart';
import 'package:flutter/material.dart';

Widget chipCustomBadge({
  required Color color,
  required String title,
  EdgeInsets? padding,
  Function()? onTap,
  bool isActive = false,
  Widget? suffixIcon,
  Widget? perfixIcon,
  TextStyle? titleStyle,
  bool isBorder = true,
  BorderRadius? borderRadius,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: onTap != null ? 3.pading : 0.pading,
      decoration:
          onTap != null
              ? BoxDecoration(
                borderRadius: 30.radius,
                border: Border.all(
                  color: isActive ? color : Colors.transparent,
                  width: isActive ? 1.5 : 1,
                ),
              )
              : null,
      child: Container(
        padding: padding ?? (12.padingHor + 6.padingVer),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          border:
              isBorder
                  ? Border.all(color: color.withValues(alpha: 0.1), width: 1.5)
                  : null,
          borderRadius: borderRadius ?? 20.radius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (perfixIcon != null) ...[perfixIcon, 4.width],
            Text(
              title,
              style:
                  titleStyle?.copyWith(color: color) ??
                  AppStyle.bodyXsBold.copyWith(color: color, height: 1),
            ).flexible(),
            if (suffixIcon != null) ...[4.width, suffixIcon],
          ],
        ),
      ),
    ),
  );
}
