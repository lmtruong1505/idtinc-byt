import 'package:tasa/core/configs/app_style/init_app_style.dart';
import 'package:tasa/core/constants/typography.dart';
import 'package:tasa/core/extension/init_ext.dart';
import 'package:tasa/core/widgets/base_container.dart';
import 'package:tasa/core/widgets/buttons/common_button.dart';
import 'package:tasa/features/asset_category/data/models/hospital_asset_model.dart';
import 'package:flutter/material.dart';

class AssetTechnicalSpecsBottomSheet extends StatelessWidget {
  const AssetTechnicalSpecsBottomSheet({super.key, required this.asset});

  final HospitalAssetModel asset;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // Handle bar
          Center(
            child: BaseContainer(
              margin: 12.padingVer,
              width: 48,
              height: 4,
              color: AppColors.grey20,
              borderRadius: 2,
              child: Container(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "Thông số kỹ thuật",
              style: AppTypography.h3.copyWith(
                color: AppColors.text_primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          8.height,
          const Divider(height: 1, color: AppColors.grey10),

          // Content
          Expanded(child: _buildEmptyState()),

          const Divider(height: 1, color: AppColors.grey10),
          // Bottom button
          Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              MediaQuery.of(context).padding.bottom + 16,
            ),
            child: CommonButton(
              title: "Đóng",
              onTap: () => Navigator.pop(context),
              buttonColor: AppColors.grey10,
              titleColor: AppColors.text_primary,
              radius: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.grey10,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.description,
              size: 32,
              color: AppColors.text_primary,
            ),
          ),
          24.height,
          Text(
            "Không có thông số kỹ thuật",
            style: AppTypography.h3.copyWith(
              color: AppColors.text_primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          8.height,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              "Không có dữ liệu khả dụng liên quan đến chức năng bạn truy cập",
              style: AppTypography.p6.copyWith(color: AppColors.text_tertiary),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
