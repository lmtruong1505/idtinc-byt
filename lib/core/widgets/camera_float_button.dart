import 'package:flutter/material.dart';
import 'package:tasa/core/constants/colors.dart';

class CameraFloatButton extends StatelessWidget {
  final Function() onPressed;
  const CameraFloatButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.grey79,
      splashColor: AppColors.grey79,
      hoverElevation: 1.5,
      shape: const StadiumBorder(
        side: BorderSide(color: AppColors.white, width: 5),
      ),
      onPressed: () {
        onPressed.call();
      },
    );
  }
}
