import 'package:tasa/core/constants/colors.dart';
import 'package:tasa/core/constants/typography.dart';
import 'package:flutter/material.dart';

Widget requiredTitle(String? title) {
  return Row(
    children: [
      Text(
        title ?? "",
        style: AppTypography.p5.copyWith(color: AppColors.blackish),
      ),
      const SizedBox(width: 4),
      Text("*", style: AppTypography.p5.copyWith(color: AppColors.red_1)),
    ],
  );
}
