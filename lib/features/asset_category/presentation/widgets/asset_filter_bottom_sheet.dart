import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/widgets/base_container.dart';
import 'package:bpg_retail/core/widgets/buttons/common_button.dart';
import 'package:bpg_retail/core/widgets/chip_custom.dart';
import 'package:bpg_retail/core/widgets/dropdown_button.dart';
import 'package:bpg_retail/features/asset_category/data/bloc/asset_filter_cubit.dart';
import 'package:bpg_retail/features/asset_category/data/bloc/asset_filter_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssetFilterBottomSheet extends StatelessWidget {
  const AssetFilterBottomSheet({super.key, required this.cubit, this.onApply});

  final AssetFilterCubit cubit;
  final VoidCallback? onApply;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssetFilterCubit, AssetFilterState>(
      bloc: cubit,
      builder: (context, state) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: BaseContainer(
            borderRadius: 16,
            color: AppColors.white,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: BaseContainer(
                    margin: 8.padingVer,
                    width: 40,
                    height: 4,
                    color: AppColors.grey_2,
                    borderRadius: 2,
                    child: Container(),
                  ),
                ),
                Padding(
                  padding: 16.padingHor,
                  child: Text(
                    "Bộ lọc",
                    style: AppTypography.h3.copyWith(color: AppColors.black),
                  ),
                ),
                16.height,
                const Divider(height: 1, color: AppColors.border_2),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: 16.pading,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Khoa phòng
                        _buildSectionTitle("Khoa phòng"),
                        8.height,
                        state.isLoadingDepartments
                            ? const Center(child: CircularProgressIndicator())
                            : CustomDropdownButton(
                              value: state.selectedDepartment,
                              hintText: "Toàn viện",
                              items: [
                                DropdownButtonModel(
                                  label: "Toàn viện",
                                  value: "all",
                                ),
                                ...state.departments.map(
                                  (dept) => DropdownButtonModel(
                                    label: dept.tenKhoa ?? "N/A",
                                    value: dept.id.toString(),
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                cubit.selectDepartment(value?.value);
                              },
                            ),
                        16.height,

                        // Trạng thái tài sản
                        _buildSectionTitle("Trạng thái tài sản"),
                        8.height,
                        state.isLoadingStatistics
                            ? const Center(child: CircularProgressIndicator())
                            : Wrap(
                              spacing: 2,
                              runSpacing: 2,
                              children:
                                  state.statistics.map((stat) {
                                    final label =
                                        "${stat.label} (${stat.count ?? 0})";
                                    final isSelected =
                                        state.selectedStatus ==
                                        (stat.value ?? "Tất cả");
                                    return chipCustomBadge(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      title: label,
                                      color:
                                          isSelected
                                              ? AppColors.main
                                              : AppColors.grey79,
                                      onTap: () {
                                        cubit.selectStatus(
                                          stat.value ?? "Tất cả",
                                        );
                                      },
                                    );
                                  }).toList(),
                            ),
                        16.height,

                        // Loại thiết bị
                        _buildSectionTitle("Loại thiết bị"),
                        8.height,
                        CustomDropdownButton(
                          value: state.selectedDeviceType,
                          hintText: "Công nghệ thông tin",
                          items: [
                            DropdownButtonModel(
                              label: "Công nghệ thông tin",
                              value: "it",
                            ),
                            DropdownButtonModel(
                              label: "Y tế",
                              value: "medical",
                            ),
                          ],
                          onChanged: (value) {
                            cubit.selectDeviceType(value?.value);
                          },
                        ),
                        24.height,

                        // Xóa bộ lọc
                        CommonButton(
                          title: "Xóa bộ lọc",
                          onTap: () {
                            cubit.clearFilter();
                          },
                          buttonColor: AppColors.red_1.withValues(alpha: 0.1),
                          titleColor: AppColors.red_1,
                        ),
                      ],
                    ),
                  ),
                ),

                const Divider(height: 1, color: AppColors.border_2),

                // Bottom Buttons
                Padding(
                  padding: 16.pading,
                  child: Row(
                    children: [
                      Expanded(
                        child: CommonButton(
                          title: "Hủy bỏ",
                          onTap: () {
                            Navigator.pop(context);
                          },
                          buttonColor: AppColors.bg_2,
                          titleColor: AppColors.black,
                        ),
                      ),
                      12.width,
                      Expanded(
                        child: CommonButton(
                          title: "Lọc danh sách",
                          onTap: () {
                            Navigator.pop(context);
                            onApply?.call();
                          },
                          buttonColor: AppColors.black,
                          titleColor: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.p5.copyWith(color: AppColors.grey79),
    );
  }
}
