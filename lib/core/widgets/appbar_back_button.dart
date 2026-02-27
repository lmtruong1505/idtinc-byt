import 'package:flutter/material.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/navigation/navigator.dart';

class AppBarBackButton extends StatelessWidget {
  AppBarBackButton({this.onTap});
  final VoidCallback? onTap;

  final navigator = getIt.get<AppNavigator>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      height: 38,
      child: InkWell(
        onTap: () => onTap == null ? navigator.pop() : onTap!.call(),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF000000).withOpacity(0.4),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}

class AppBarBackButtonV2 extends StatelessWidget {
  AppBarBackButtonV2({this.onTap});
  final VoidCallback? onTap;

  final navigator = getIt.get<AppNavigator>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap == null ? navigator.pop() : onTap!.call(),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.bg_3),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_back_ios, color: Colors.black, size: 22),
            Text("Trờ lại", style: s16w500),
          ],
        ),
      ),
    );
  }
}
