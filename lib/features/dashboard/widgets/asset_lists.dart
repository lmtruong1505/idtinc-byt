import 'package:tasa/core/configs/app_style/init_app_style.dart';
import 'package:tasa/core/extension/spacing_extension.dart';
import 'package:tasa/core/ext/ext_num.dart';
import 'package:tasa/core/widgets/base_container.dart';
import 'package:tasa/core/utilities/enum.dart';
import 'package:tasa/features/dashboard/presentation/bloc/asset_quantity_cubit.dart';
import 'package:tasa/features/dashboard/presentation/bloc/asset_quantity_state.dart';
import 'package:tasa/features/dashboard/presentation/bloc/depreciation_rate_cubit.dart';
import 'package:tasa/features/dashboard/presentation/bloc/depreciation_rate_state.dart';
import 'package:tasa/features/dashboard/presentation/bloc/asset_status_ratio_cubit.dart';
import 'package:tasa/features/dashboard/presentation/bloc/asset_status_ratio_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssetListsWidget extends StatefulWidget {
  const AssetListsWidget({super.key});

  @override
  State<AssetListsWidget> createState() => _AssetListsWidgetState();
}

class _AssetListsWidgetState extends State<AssetListsWidget> {
  int _selectedTabIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAssetQuantitySection(),
        24.height,
        _buildDepreciationRateSection(),
        24.height,
        _buildAssetStatusSection(),
      ],
    );
  }

  Widget _buildAssetQuantitySection() {
    return BlocBuilder<AssetQuantityCubit, AssetQuantityState>(
      builder: (context, state) {
        if (state.status == CubitStatus.loading) {
          return const BaseContainer(
            padding: EdgeInsets.all(24),
            borderRadius: 24,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final items =
            _selectedTabIndex == 0
                ? state.data?.khoa ?? []
                : state.data?.loaiTaiSan ?? [];

        return BaseContainer(
          padding: const EdgeInsets.all(24),
          borderRadius: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Số lượng tài sản",
                style: AppStyle.headingXl.copyWith(
                  color: const Color(0xFF201B51),
                ),
              ),
              16.height,
              Row(
                children: [
                  _buildTabItem(0, "Theo khoa phòng"),
                  _buildTabItem(1, "Theo loại tài sản"),
                ],
              ),
              16.height,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedTabIndex == 0 ? "Khoa/Phòng" : "Loại tài sản",
                      style: AppStyle.headingBs,
                    ),
                    Text("Tổng nguyên giá", style: AppStyle.headingBs),
                  ],
                ),
              ),
              12.height,
              const Divider(height: 1, color: AppColors.grey20),
              SizedBox(
                height: items.isEmpty ? 100 : 240,
                child:
                    items.isEmpty
                        ? const Center(child: Text("Không có dữ liệu"))
                        : RawScrollbar(
                          controller: _scrollController,
                          thickness: 4,
                          radius: const Radius.circular(3),
                          thumbColor: AppColors.grey60.withOpacity(0.5),
                          thumbVisibility: true,
                          child: ListView.separated(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: items.length,
                            separatorBuilder:
                                (context, index) => const Divider(
                                  height: 1,
                                  color: AppColors.grey20,
                                ),
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return _buildListItem(
                                item.name,
                                item.totalOriginalPrice.formatVND,
                              );
                            },
                          ),
                        ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabItem(int index, String title) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? const Color(0xFF201B51) : AppColors.grey20,
                width: isSelected ? 3 : 1,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style:
                isSelected
                    ? AppStyle.bodyMdSemiBold.copyWith(
                      color: const Color(0xFF201B51),
                    )
                    : AppStyle.bodyMdRegular.copyWith(
                      color: AppColors.text_tertiary,
                    ),
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(String title, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(title, style: AppStyle.bodyBsRegular)),
          Text(price, style: AppStyle.bodyBsSemiBold),
        ],
      ),
    );
  }

  Widget _buildDepreciationRateSection() {
    return BlocBuilder<DepreciationRateCubit, DepreciationRateState>(
      builder: (context, state) {
        if (state.status == CubitStatus.loading) {
          return const BaseContainer(
            padding: EdgeInsets.all(24),
            borderRadius: 24,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final items = state.data;

        return BaseContainer(
          padding: const EdgeInsets.all(24),
          borderRadius: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tỷ lệ hao mòn tài sản",
                style: AppStyle.headingXl.copyWith(
                  color: const Color(0xFF201B51),
                ),
              ),
              12.height,
              const Divider(color: AppColors.grey20, height: 1),
              12.height,
              if (items.isEmpty)
                const Center(child: Text("Không có dữ liệu"))
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _buildProgressBar(
                      label: item.label ?? "",
                      color: _parseColor(item.color),
                      percent: (item.percent ?? 0).toDouble() / 100,
                      labelColor: _parseColor(item.color),
                      value: item.value?.toString() ?? "0",
                    );
                  },
                  separatorBuilder:
                      (context, index) =>
                          const Divider(color: AppColors.grey20, height: 24),
                ),
            ],
          ),
        );
      },
    );
  }

  Color _parseColor(String? colorStr) {
    if (colorStr == null || colorStr.isEmpty) return AppColors.main;
    try {
      final buffer = StringBuffer();
      if (colorStr.length == 6 || colorStr.length == 7) buffer.write('ff');
      buffer.write(colorStr.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      return AppColors.main;
    }
  }

  Widget _buildAssetStatusSection() {
    return BlocBuilder<AssetStatusRatioCubit, AssetStatusRatioState>(
      builder: (context, state) {
        if (state.status == CubitStatus.loading) {
          return const BaseContainer(
            padding: EdgeInsets.all(24),
            borderRadius: 24,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final items = state.data;

        return BaseContainer(
          padding: const EdgeInsets.all(24),
          borderRadius: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tỷ lệ trạng thái tài sản",
                style: AppStyle.headingXl.copyWith(
                  color: const Color(0xFF201B51),
                ),
              ),
              12.height,
              const Divider(color: AppColors.grey20, height: 1),
              12.height,
              if (items.isEmpty)
                const Center(child: Text("Không có dữ liệu"))
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _buildProgressBar(
                      label: item.label ?? "",
                      color: AppColors.main,
                      percent: (item.percent ?? 0).toDouble() / 100,
                      price:
                          item.amount != null ? item.amount.formatVND : "0 đ",
                      value: item.value?.toString() ?? "0",
                      labelColor: _parseColor(item.labelColor),
                    );
                  },
                  separatorBuilder:
                      (context, index) =>
                          const Divider(color: AppColors.grey20, height: 12),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressBar({
    required String label,
    required Color color,
    required double percent,
    String? price,
    Color? labelColor,
    String? value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppStyle.bodyMdSemiBold.copyWith(
                      color: labelColor ?? AppColors.grey60,
                    ),
                  ),
                  if (price != null) ...[
                    4.height,

                    BaseContainer(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 12,
                      ),
                      borderRadius: 20,
                      color: AppColors.grey20.withOpacity(0.5),
                      child: Text(
                        price,
                        textAlign: TextAlign.center,
                        style: AppStyle.bodySmSemiBold.copyWith(
                          color: AppColors.text_tertiary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            12.width,
            Text(value ?? "0", style: AppStyle.headingXl),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: percent,
                  backgroundColor: AppColors.grey20,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 12,
                ),
              ),
            ),
            20.width,
            _buildPercentageBubble(percent),
          ],
        ),
      ],
    );
  }

  Widget _buildPercentageBubble(double percent) {
    return SizedBox(
      width: 55,
      child: BaseContainer(
        padding: const EdgeInsets.symmetric(vertical: 4),
        borderRadius: 20,
        color: AppColors.grey20.withOpacity(0.5),
        child: Text(
          "${(percent * 100).formatPercent()}%",
          textAlign: TextAlign.center,
          style: AppStyle.bodySmSemiBold.copyWith(
            color: AppColors.text_tertiary,
          ),
        ),
      ),
    );
  }
}
