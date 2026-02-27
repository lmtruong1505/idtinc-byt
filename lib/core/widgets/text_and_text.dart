import 'package:flutter/material.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';

import '../constants/colors.dart';
import '../constants/typography.dart';

Widget TextAndText({
  required String title,
  required String subtitle,
  TextAlign textAlign = TextAlign.right,
  TextStyle? style,
  CrossAxisAlignment? crossAxisAlignment,
  Key? key,
  Widget? icon,
  bool isExpanded = true,
}) {
  return Row(
    crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
    children: [
      Text(title, style: s14w400.copyWith(color: AppColors.grey79)),
      8.width,
      isExpanded
          ? Text(
            subtitle,
            style: style ?? s14w400,
            textAlign: textAlign,
          ).expanded()
          : Text(
            subtitle,
            style: style ?? s14w400,
            textAlign: textAlign,
          ).flexible(),
      if (icon != null) icon,
    ],
  );
}
