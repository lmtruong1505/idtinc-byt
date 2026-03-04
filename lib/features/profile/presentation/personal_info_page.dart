import 'package:tasa/core/constants/colors.dart';
import 'package:tasa/core/constants/typography.dart';
import 'package:tasa/core/extension/spacing_extension.dart';
import 'package:tasa/core/injection/injection.dart';
import 'package:tasa/core/preferences/preferences.dart';
import 'package:tasa/core/widgets/base_container.dart';
import 'package:tasa/core/widgets/buttons/common_button.dart';
import 'package:tasa/core/widgets/buttons/dashed_button.dart';
import 'package:tasa/core/widgets/fa_icon.dart';
import 'package:tasa/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:tasa/app/data/bloc/app_cubit.dart';

class PersonalInfoPage extends StatelessWidget {
  const PersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appCubit = getIt.get<AppCubit>();
    final preferences = getIt.get<Preferences>();
    final user = preferences.getUserData;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          "Chức năng khác",
          style: AppTypography.h3.copyWith(color: AppColors.black),
        ),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: AppColors.greyEE, height: 1, thickness: 1),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    // User Profile Card
                    BaseContainer(
                      padding: const EdgeInsets.all(12),
                      borderRadius: 100,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      child: Row(
                        children: [
                          BaseContainer(
                            width: 60,
                            height: 60,
                            isCircle: true,
                            color: AppColors.greyEE,
                            child:
                                user.hinhAnh != null
                                    ? ClipOval(
                                      child: Image.network(
                                        user.hinhAnh!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                    : const Icon(
                                      Icons.person,
                                      size: 30,
                                      color: AppColors.grey79,
                                    ),
                          ),
                          16.width,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Xin chào,",
                                  style: AppTypography.p6.copyWith(
                                    color: AppColors.grey79,
                                  ),
                                ),
                                4.height,
                                Text(
                                  user.hoVaTen ?? "Người dùng",
                                  style: AppTypography.h4.copyWith(
                                    color: AppColors.blackish,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    50.height,

                    // Version Section
                    BaseContainer(
                      width: 44,
                      height: 44,
                      isCircle: true,
                      color: AppColors.greyEE,
                      borderColor: AppColors.greyD9,
                      child: Center(
                        child: FaIcon(
                          iconCode: 'f10b', // mobile phone
                          size: 20,
                          color: AppColors.blackish,
                        ),
                      ),
                    ),
                    12.height,
                    Text(
                      "Version 1.0",
                      style: AppTypography.h4.copyWith(
                        color: AppColors.blackish,
                      ),
                    ),
                    8.height,
                    Text(
                      "Bạn đang sử dụng ứng dụng phiên bản 1.0",
                      style: AppTypography.p6.copyWith(
                        color: AppColors.greyTextColor,
                      ),
                    ),
                    16.height,
                    DashedButton(
                      title: "Nâng cấp phiên bản mới nhất",
                      color: AppColors.greyD9,
                      textColor: AppColors.grey79,
                      icon: FaIcon(
                        iconCode: 'f3bf', // circle-chevron-up
                        size: 14,
                        color: AppColors.grey79,
                      ),
                      onTap: () {},
                    ),
                    50.height,

                    // Organization Access Part
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(color: AppColors.greyE2, thickness: 1),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "Bạn đang truy cập",
                            style: AppTypography.p7.copyWith(
                              color: AppColors.grey79,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(color: AppColors.greyE2, thickness: 1),
                        ),
                      ],
                    ),
                    32.height,
                    Image.asset(
                      'assets/images/TASA_logo.png',
                      height: 60,
                      width: 60,
                    ),
                    16.height,
                    Text(
                      "Bệnh viện đa khoa huyện Quốc Oai",
                      textAlign: TextAlign.center,
                      style: AppTypography.h4.copyWith(
                        color: AppColors.blackish,
                        height: 1.4,
                      ),
                    ),
                    16.height,
                    DashedButton(
                      title: "Thoát khỏi tổ chức",
                      color: AppColors.greyD9,
                      textColor: AppColors.grey79,
                      icon: FaIcon(
                        iconCode: 'f35a', // circle-arrow-right
                        size: 14,
                        color: AppColors.grey79,
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Actions
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              child: Row(
                children: [
                  Expanded(
                    child: CommonButton(
                      title: "Xóa tài khoản",
                      buttonColor: AppColors.red_1,
                      titleColor: AppColors.white,
                      onTap: () {
                        // Logic xóa tài khoản
                      },
                    ),
                  ),
                  16.width,
                  Expanded(
                    child: CommonButton(
                      title: "Đăng xuất",
                      buttonColor: const Color(0xFFFFEBEE), // Light Red
                      titleColor: AppColors.red_1,
                      onTap: () {
                        _showLogoutDialog(context, appCubit);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AppCubit appCubit) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Đăng xuất"),
            content: const Text("Bạn có chắc chắn muốn đăng xuất không?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  "Hủy",
                  style: AppTypography.p5.copyWith(color: AppColors.grey79),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  appCubit.onForceLogout();
                },
                child: Text(
                  "Đăng xuất",
                  style: AppTypography.p5.copyWith(color: AppColors.red_1),
                ),
              ),
            ],
          ),
    );
  }
}
