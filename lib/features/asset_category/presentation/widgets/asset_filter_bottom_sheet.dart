import 'package:tasa/core/constants/colors.dart';
import 'package:tasa/core/constants/typography.dart';
import 'package:tasa/core/extension/init_ext.dart';
import 'package:tasa/core/widgets/base_container.dart';
import 'package:tasa/core/widgets/buttons/common_button.dart';
import 'package:tasa/core/widgets/chip_custom.dart';
import 'package:tasa/core/widgets/dropdown_button.dart';
import 'package:tasa/features/asset_category/data/bloc/asset_filter_cubit.dart';
import 'package:tasa/features/asset_category/data/bloc/asset_filter_state.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssetFilterBottomSheet extends StatefulWidget {
  const AssetFilterBottomSheet({super.key, required this.cubit, this.onApply});

  final AssetFilterCubit cubit;
  final VoidCallback? onApply;

  @override
  State<AssetFilterBottomSheet> createState() => _AssetFilterBottomSheetState();
}

class _AssetFilterBottomSheetState extends State<AssetFilterBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  bool _isDepartmentMenuOpen = false;

  @override
  void initState() {
    super.initState();
    widget.cubit.getAssetTypes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssetFilterCubit, AssetFilterState>(
      bloc: widget.cubit,
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
                                widget.cubit.selectDepartment(value?.value);
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(4),
                                  border:
                                      _isDepartmentMenuOpen
                                          ? Border.all(
                                            color: AppColors.main,
                                            width: 2,
                                          )
                                          : Border.all(
                                            color: AppColors.grey_1,
                                            width: 1.2,
                                          ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                width: double.infinity,
                              ),
                              dropdownSearchData: DropdownSearchData(
                                searchController: _searchController,
                                searchInnerWidgetHeight: 64,
                                searchInnerWidget: Container(
                                  height: 64,
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    16,
                                    16,
                                    8,
                                  ),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: AppColors.border_2,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: TextFormField(
                                    expands: true,
                                    maxLines: null,
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                      hintText: 'Tìm kiếm',
                                      hintStyle: AppTypography.p6,
                                      prefixIcon: const Icon(
                                        Icons.search,
                                        size: 20,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: AppColors.border_2,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: AppColors.border_2,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: AppColors.main,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                searchMatchFn: (item, searchValue) {
                                  return item.value?.label
                                          .toLowerCase()
                                          .contains(
                                            searchValue.toLowerCase(),
                                          ) ??
                                      false;
                                },
                              ),
                              onMenuStateChange: (isOpen) {
                                setState(() {
                                  _isDepartmentMenuOpen = isOpen;
                                });
                                if (!isOpen) {
                                  _searchController.clear();
                                }
                              },
                              showDivider: true,
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: AppColors.white,
                                ),
                                maxHeight: 400,
                                offset: const Offset(0, 4),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 48,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                              ),
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
                                      isActive: isSelected,
                                      title: label,
                                      color:
                                          isSelected
                                              ? AppColors.green_1
                                              : AppColors.grey79,
                                      onTap: () {
                                        widget.cubit.selectStatus(
                                          stat.value ?? "Tất cả",
                                        );
                                      },
                                    );
                                  }).toList(),
                            ),
                        16.height,

                        // Loại tài sản
                        _buildSectionTitle("Loại tài sản"),
                        8.height,
                        state.isLoadingAssetTypes
                            ? const Center(child: CircularProgressIndicator())
                            : CustomDropdownButton(
                              value: state.selectedAssetTypeId,
                              hintText: "Chọn",
                              items: [
                                DropdownButtonModel(
                                  label: "Tất cả",
                                  value: "all",
                                ),
                                ...state.assetTypes.map(
                                  (type) => DropdownButtonModel(
                                    label: type.tenDanhMuc ?? "N/A",
                                    value: type.id,
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                widget.cubit.selectAssetType(value?.value);
                              },
                            ),
                        24.height,

                        // Xóa bộ lọc
                        CommonButton(
                          title: "Xóa bộ lọc",
                          onTap: () {
                            widget.cubit.clearFilter();
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
                            widget.onApply?.call();
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
    return Row(
      children: [
        Text(title, style: AppTypography.p5.copyWith(color: AppColors.grey79)),
        8.width,
        const Expanded(child: Divider(color: AppColors.grey_2, height: 1)),
      ],
    );
  }
}
