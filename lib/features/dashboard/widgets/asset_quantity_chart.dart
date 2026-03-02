import 'package:tasa/core/configs/app_style/init_app_style.dart';
import 'package:tasa/core/extension/spacing_extension.dart';
import 'package:tasa/core/ext/ext_num.dart';
import 'package:tasa/core/utilities/enum.dart';
import 'package:tasa/core/widgets/base_container.dart';
import 'package:tasa/core/constants/typography.dart';
import 'package:tasa/features/asset_category/data/models/asset_quantity_report_model.dart';
import 'package:tasa/features/dashboard/presentation/bloc/asset_quantity_cubit.dart';
import 'package:tasa/features/dashboard/presentation/bloc/asset_quantity_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssetQuantityChartWidget extends StatefulWidget {
  const AssetQuantityChartWidget({super.key});

  @override
  State<AssetQuantityChartWidget> createState() =>
      _AssetQuantityChartWidgetState();
}

class _AssetQuantityChartWidgetState extends State<AssetQuantityChartWidget> {
  bool _isByDepartment = true;

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      padding: EdgeInsets.zero,
      borderRadius: 16,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Text(
              "Số lượng tài sản",
              style: AppTypography.h3.copyWith(
                color: const Color(0xff22215B),
                fontSize: 28,
              ),
            ),
          ),
          24.height,
          _buildTabs(),
          const Divider(height: 1, color: AppColors.grey20),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isByDepartment ? "Khoa/Phòng" : "Loại tài sản",
                  style: AppTypography.h4.copyWith(
                    color: const Color(0xff22215B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Tổng nguyên giá",
                  style: AppTypography.h4.copyWith(
                    color: const Color(0xff22215B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Divider(height: 1, color: AppColors.grey20),
          ),
          BlocBuilder<AssetQuantityCubit, AssetQuantityState>(
            builder: (context, state) {
              if (state.status == CubitStatus.loading) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (state.status == CubitStatus.error) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(child: Text(state.message)),
                );
              }

              final items =
                  _isByDepartment
                      ? state.data?.khoa ?? []
                      : state.data?.loaiTaiSan ?? [];

              if (items.isEmpty && state.status == CubitStatus.success) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text("Không có dữ liệu")),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                separatorBuilder:
                    (context, index) =>
                        const Divider(height: 1, color: AppColors.grey20),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _buildItem(item);
                },
              );
            },
          ),
          12.height,
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      children: [
        _buildTabItem("Theo khoa phòng", _isByDepartment, () {
          setState(() => _isByDepartment = true);
        }),
        _buildTabItem("Theo loại tài sản", !_isByDepartment, () {
          setState(() => _isByDepartment = false);
        }),
      ],
    );
  }

  Widget _buildTabItem(String label, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                label,
                style: AppTypography.h4.copyWith(
                  color:
                      isSelected ? const Color(0xff22215B) : AppColors.grey40,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            Container(
              height: 2,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color:
                    isSelected ? const Color(0xff22215B) : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(AssetQuantityItemModel item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              item.name,
              style: AppTypography.p3.copyWith(
                color: const Color(0xff22215B),
                fontWeight: FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          16.width,
          Text(
            item.totalOriginalPrice.formatVND,
            style: AppTypography.p3.copyWith(
              color: const Color(0xff22215B),
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
