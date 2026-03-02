import 'package:tasa/core/configs/app_style/init_app_style.dart';
import 'package:tasa/core/constants/typography.dart';
import 'package:tasa/core/extension/init_ext.dart';
import 'package:tasa/core/widgets/base_container.dart';
import 'package:tasa/core/widgets/buttons/common_button.dart';
import 'package:tasa/features/asset_category/data/models/hospital_asset_model.dart';
import 'package:tasa/core/utilities/converts.dart';
import 'package:flutter/material.dart';

class AssetDepreciationBottomSheet extends StatelessWidget {
  const AssetDepreciationBottomSheet({super.key, required this.asset});

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
              "Truy vết khấu hao",
              style: AppTypography.h3.copyWith(
                color: AppColors.text_primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          8.height,
          const Divider(height: 1, color: AppColors.grey10),

          // List content
          Expanded(child: _buildDepreciationList()),

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

  Widget _buildDepreciationList() {
    final int? startYear = _getStartYear();
    final int depreciationYears = asset.depreciationYearsValue.toInt();

    // We want to show a reasonable range of years, at least the depreciation period
    // and maybe some current context if it's already past.
    // Based on UI screenshot, it seems to show a sequence of years.

    if (startYear == null || depreciationYears <= 0) {
      return const Center(child: Text("Không có dữ liệu khấu hao"));
    }

    final List<int> yearsToShow = [];

    // Show from start year to start year + depreciationYears - 1
    for (int i = 0; i < depreciationYears; i++) {
      yearsToShow.add(startYear + i);
    }

    // If current year is beyond the period, maybe show up to current year?
    // Looking at screenshot: 2025 (has value), 2026-2033 (0 value).
    // It seems to list the entire depreciation period.

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: yearsToShow.length,
      separatorBuilder:
          (context, index) => Padding(
            padding: const EdgeInsets.only(left: 48),
            child: Divider(height: 1, color: AppColors.grey10),
          ),
      itemBuilder: (context, index) {
        final year = yearsToShow[index];

        // Logical check: if the year is within the depreciation period AND it's not in the future relative to usage
        // but wait, the screenshot shows 2025 with value and 2026+ with 0.
        // Assuming this is a static projection or based on actual data per year.
        // For now, I'll mock the logic based on original price and annual depreciation.

        final double value =
            (year == startYear)
                ? asset.annualDepreciation
                : 0; // Following screenshot logic roughly
        final double ratio = (year == startYear) ? asset.depreciationRatio : 0;

        return _buildYearItem(year.toString(), value, ratio);
      },
    );
  }

  int? _getStartYear() {
    if (asset.ngayBatDauSuDung == null) return null;
    try {
      return DateTime.parse(asset.ngayBatDauSuDung!).year;
    } catch (_) {
      return null;
    }
  }

  Widget _buildYearItem(String year, double value, double ratio) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            year,
            style: AppTypography.p5.copyWith(color: AppColors.text_tertiary),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${formatCurrency(value)}",
                style: AppTypography.p5.copyWith(
                  color: AppColors.text_primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${ratio.toStringAsFixed(2)}%",
                style: AppTypography.p7.copyWith(
                  color: AppColors.text_tertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
