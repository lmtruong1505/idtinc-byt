import 'package:tasa/core/utilities/enum.dart';
import 'package:tasa/core/ext/ext_num.dart';
import 'package:tasa/features/dashboard/presentation/bloc/asset_overview_cubit.dart';
import 'package:tasa/features/dashboard/presentation/bloc/asset_overview_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasa/core/configs/app_style/init_app_style.dart';
import 'package:tasa/core/constants/typography.dart';
import 'package:tasa/core/extension/spacing_extension.dart';
import 'package:tasa/core/widgets/base_container.dart';
import 'package:flutter/material.dart';

class OverviewCards extends StatelessWidget {
  const OverviewCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: AppColors.grey20)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Tổng quan tài sản",
                style: AppTypography.p5.copyWith(
                  color: AppColors.text_tertiary,
                ),
              ),
            ),
            Expanded(child: Divider(color: AppColors.grey20)),
          ],
        ),
        16.height,
        BlocBuilder<AssetOverviewCubit, AssetOverviewState>(
          builder: (context, state) {
            String quantity = "---";
            String price = "--- đ";

            if (state.status == CubitStatus.success && state.data != null) {
              quantity = (state.data!.tongSoLuong ?? 0).formatNumber;
              price = "${(state.data!.tongNguyenGia ?? 0).formatNumber} đ";
            }

            return Row(
              children: [
                Expanded(
                  child: _buildCard(
                    title: "Tổng số lượng",
                    adjust: quantity,
                    color: AppColors.main,
                  ),
                ),
                12.width,
                Expanded(
                  child: _buildCard(
                    title: "Tổng nguyên giá",
                    adjust: price,
                    color: AppColors.main,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    required String adjust,
    required Color color,
  }) {
    return BaseContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      color: color,
      boxShadow: [
        BoxShadow(
          color: color.withValues(alpha: 0.3),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.p7.copyWith(color: Colors.white70)),
          8.height,
          Text(
            adjust,
            style: AppTypography.h5.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
