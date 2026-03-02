import 'package:tasa/core/configs/app_style/init_app_style.dart';
import 'package:tasa/core/constants/typography.dart';
import 'package:tasa/core/extension/spacing_extension.dart';
import 'package:tasa/core/utilities/converts.dart';
import 'package:tasa/core/widgets/base_container.dart';
import 'package:tasa/core/widgets/base_progress_bar.dart';
import 'package:tasa/core/widgets/chip_custom.dart';
import 'package:tasa/features/asset_category/data/models/hospital_asset_model.dart';
import 'package:tasa/features/asset_category/data/bloc/asset_detail_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasa/core/utilities/dialog_utils.dart';
import 'package:flutter/material.dart';

class AssetSetBottomSheet extends StatelessWidget {
  final HospitalAssetModel mainAsset;
  const AssetSetBottomSheet({super.key, required this.mainAsset});

  @override
  Widget build(BuildContext context) {
    // Separate main and accompanying assets
    final List<HospitalAssetModel> setAssets = mainAsset.boTaiSan ?? [];
    final HospitalAssetModel? parentAsset = setAssets.firstWhere(
      (a) => a.isParent == true,
      orElse: () => mainAsset,
    );
    final List<HospitalAssetModel> childrenAssets =
        setAssets.where((a) => a.isParent == false).toList();

    // Check if the current asset is a parent in the set
    final isCurrentAssetParent = setAssets.any(
      (a) => a.id == mainAsset.id && a.isParent == true,
    );

    return BaseContainer(
      width: double.infinity,
      color: AppColors.white,
      borderRadius: 16,
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey30,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          16.height,
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Bộ tài sản",
              style: AppTypography.h3.copyWith(
                color: AppColors.text_primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          16.height,
          const Divider(height: 1, color: AppColors.grey20),

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Asset Section
                  _buildSectionDivider("Tài sản chính"),
                  16.height,
                  _AssetSetItemWidget(asset: parentAsset!, isMain: true),

                  // Accompanying Assets Section
                  if (childrenAssets.isNotEmpty) ...[
                    24.height,
                    _buildSectionDivider(
                      "Tài sản đi kèm (${childrenAssets.length})",
                    ),
                    16.height,
                    ...childrenAssets.map(
                      (child) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _AssetSetItemWidget(asset: child, isMain: false),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Bottom Actions
          _buildBottomActions(context, isCurrentAssetParent),
        ],
      ),
    );
  }

  Widget _buildSectionDivider(String label) {
    return Row(
      children: [
        const Expanded(child: Divider(height: 1, color: AppColors.grey20)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: AppTypography.p7.copyWith(color: AppColors.text_tertiary),
          ),
        ),
        const Expanded(child: Divider(height: 1, color: AppColors.grey20)),
      ],
    );
  }

  Widget _buildBottomActions(BuildContext context, bool canSeparate) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: BaseContainer(
                padding: const EdgeInsets.symmetric(vertical: 12),
                borderRadius: 24,
                color: AppColors.grey10,
                child: Center(
                  child: Text(
                    "Đóng",
                    style: AppTypography.p5.copyWith(
                      color: AppColors.text_primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          12.width,
          Expanded(
            child: Opacity(
              opacity: canSeparate ? 1.0 : 0.4,
              child: GestureDetector(
                onTap:
                    canSeparate
                        ? () {
                          DialogUtils.showActionConfirmDialog(
                            context,
                            title: "Tách khỏi bộ tài sản",
                            description:
                                "Thao tác này không được hoàn tác. Bạn có chắc chắn muốn xác nhận tách tài sản này khỏi bộ tài sản?",
                            onConfirm: () {
                              context.read<AssetDetailCubit>().separateFromSet(
                                mainAsset.id!,
                              );
                              Navigator.pop(context); // Close BottomSheet
                            },
                          );
                        }
                        : null,
                child: BaseContainer(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  borderRadius: 24,
                  color: const Color(0xFFFFE5E5),
                  child: Center(
                    child: Text(
                      "Tách khỏi bộ",
                      style: AppTypography.p5.copyWith(
                        color: const Color(0xFFFF4D4D),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AssetSetItemWidget extends StatelessWidget {
  final HospitalAssetModel asset;
  final bool isMain;
  const _AssetSetItemWidget({required this.asset, required this.isMain});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            BaseContainer(
              width: 70,
              height: 70,
              borderRadius: 8,
              color: AppColors.grey10,
              child:
                  asset.hinhAnh != null
                      ? Image.network(asset.hinhAnh!, fit: BoxFit.contain)
                      : const Icon(Icons.image, color: AppColors.grey40),
            ),
            12.width,
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        asset.maTaiSan ?? "N/A",
                        style: AppTypography.p5.copyWith(
                          color: AppColors.text_tertiary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      chipCustomBadge(
                        color: getAssetStatusColor(asset.trangThai?.value),
                        title: asset.trangThai?.label ?? "Chưa xác định",
                        titleStyle: AppTypography.p7.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  4.height,
                  Text(
                    asset.tenTaiSan ?? "N/A",
                    style: AppTypography.p4.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.text_primary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  4.height,
                  Text(
                    "${formatCurrency(asset.originalPriceValue)} (${asset.thoiGianTinhKhauHao ?? '0'} năm, từ ${convertDateFormat(asset.ngayBatDauSuDung ?? '')})",
                    style: AppTypography.p7.copyWith(
                      color: AppColors.text_tertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        12.height,
        // Progress Bar
        BaseProgressBar(
          value: asset.accumulatedDepreciationRatio,
          progressColor: isMain ? AppColors.green60 : const Color(0xFFFFA000),
          backgroundColor: AppColors.grey10,
          height: 6,
        ),
        8.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Đã hao mòn: ${formatCurrency(asset.accumulatedDepreciation)}",
              style: AppTypography.p7.copyWith(color: AppColors.text_tertiary),
            ),
            Text(
              "Còn ${formatCurrency(asset.remainingValue)}",
              style: AppTypography.p7.copyWith(
                color: AppColors.text_primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
