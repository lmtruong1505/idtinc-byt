import 'package:flutter/material.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';

import '../constants/colors.dart';
import '../constants/typography.dart';

Row TextTitel({required String title}) {
  return Row(
    children: [
      Container(
        height: 24,
        width: 5,
        decoration: BoxDecoration(
          color: AppColors.main,
          borderRadius: 50.radius,
        ),
      ),
      8.width,
      Text(title, style: s18w700, overflow: TextOverflow.ellipsis).expanded(),
    ],
  );
}
