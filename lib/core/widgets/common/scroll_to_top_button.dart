import 'package:tasa/core/configs/app_style/init_app_style.dart';
import 'package:tasa/core/widgets/buttons/label_button.dart';
import 'package:flutter/material.dart';

class ScrollToTopButton extends StatelessWidget {
  final bool show;
  final VoidCallback onTap;

  const ScrollToTopButton({super.key, required this.show, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: show ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: IgnorePointer(
        ignoring: !show,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: LabelButton(
            label: 'Lên đầu',
            onPressed: onTap,
            backgroundColor: AppColors.blueAlpha10,
            labelStyle: s14w500.copyWith(color: AppColors.blue60, height: 1),
            prefixIcon: const Icon(
              Icons.arrow_upward,
              color: AppColors.blue60,
              size: 16,
            ),
            radius: BorderRadius.circular(99),
            isBorder: false,
          ),
        ),
      ),
    );
  }
}
