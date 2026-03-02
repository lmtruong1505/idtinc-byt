import 'package:flutter/material.dart';
import 'package:tasa/core/constants/colors.dart';

class BaseCheckbox extends StatelessWidget {
  const BaseCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.radius = 4,
  });

  final bool value;
  final double radius;
  final Function(bool? value) onChanged;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      side: const BorderSide(width: 1.5, color: AppColors.border_2),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      splashRadius: 8,
      checkColor: AppColors.white,
      activeColor: AppColors.main,
      value: value,
      onChanged: (value) {
        onChanged.call(value);
      },
    );
  }
}
