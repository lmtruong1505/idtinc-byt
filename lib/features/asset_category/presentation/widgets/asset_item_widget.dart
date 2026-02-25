import 'package:auto_route/auto_route.dart';
import 'package:bpg_retail/app/routes/router.gr.dart';
import 'package:bpg_retail/core/configs/app_style/init_app_style.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/core.dart' hide AppColors;
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:bpg_retail/core/utilities/converts.dart';
import 'package:bpg_retail/core/widgets/base_container.dart';
import 'package:bpg_retail/core/widgets/base_progress_bar.dart';
import 'package:bpg_retail/core/widgets/chip_custom.dart';
import 'package:bpg_retail/features/asset_category/data/bloc/asset_category_cubit.dart';
import 'package:bpg_retail/features/asset_category/data/models/hospital_asset_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssetItemWidget extends StatelessWidget {
  final HospitalAssetModel asset;
  const AssetItemWidget({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await context.router.push(AssetDetailRoute(asset: asset));
        if (context.mounted) {
          context.read<AssetCategoryCubit>().getAssets(refresh: true);
        }
      },
      child: BaseContainer(
        margin: 8.padingVer + 8.padingHor,
        padding: const EdgeInsets.all(12),
        borderRadius: 12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Asset Image
                BaseContainer(
                  width: 80,
                  height: 80,
                  borderRadius: 8,
                  color: AppColors.grey20,
                  child:
                      asset.hinhAnh != null
                          ? Image.network(
                            asset.hinhAnh!,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => const Icon(
                                  Icons.image,
                                  color: AppColors.text_tertiary,
                                ),
                          )
                          : const Icon(
                            Icons.image,
                            color: AppColors.text_tertiary,
                          ),
                ),
                12.width,
                // Asset Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            asset.maTaiSan ?? 'N/A',
                            style: AppTypography.p5.copyWith(
                              color: AppColors.text_tertiary,
                            ),
                          ),
                          // Status Badge
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
                          fontWeight: FontWeight.w600,
                          color: AppColors.text_primary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      4.height,
                      Text(
                        "${formatCurrency(double.tryParse(asset.nguyenGia ?? '0'))} (${asset.thoiGianTinhKhauHao ?? '0'} năm, từ ${convertDateFormat(asset.ngayBatDauSuDung ?? '')})",
                        style: AppTypography.p6.copyWith(
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
            BaseProgressBar(value: asset.depreciationRatio),
            8.height,
            // Depreciation Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Đã hao mòn: ${formatCurrency(asset.annualDepreciation)}",
                  style: AppTypography.p6.copyWith(
                    color: AppColors.text_tertiary,
                  ),
                ),
                Text(
                  "Còn ${formatCurrency(asset.remainingValue)}",
                  style: AppTypography.p6.copyWith(
                    color: AppColors.text_primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            12.height,
            // Footer
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.layers_outlined,
                    size: 16,
                    color: AppColors.text_tertiary,
                  ),
                  6.width,
                  Text(
                    asset.hasBoTaiSan == true
                        ? "Đã có tài sản đi kèm"
                        : "Chưa có tài sản đi kèm",
                    style: AppTypography.p6.copyWith(
                      color: AppColors.text_tertiary,
                    ),
                  ),
                ],
              ),
            ),
            12.height,
            const Divider(height: 1, color: AppColors.border_tertiary),
          ],
        ),
      ),
    );
  }
}
