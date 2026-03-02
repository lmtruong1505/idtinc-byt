import 'package:tasa/core/configs/app_style/init_app_style.dart';
import 'package:tasa/core/constants/typography.dart';
import 'package:tasa/core/widgets/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:tasa/core/extension/init_ext.dart';
import 'package:tasa/core/injection/injection.dart';
import 'package:tasa/core/preferences/preferences.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final preferences = getIt.get<Preferences>();
    final user = preferences.getUserData;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          AvatarWidget(url: user.hinhAnh ?? '', size: 48),
          12.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Xin chào,",
                style: AppTypography.p6.copyWith(
                  color: AppColors.text_tertiary,
                ),
              ),
              Text(
                user.hoVaTen ?? "Người dùng",
                style: AppTypography.p4.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackAlpha70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
