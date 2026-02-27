import 'package:bpg_retail/core/configs/app_style/init_app_style.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:bpg_retail/core/widgets/base_container.dart';
import 'package:flutter/material.dart';

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
    return BaseContainer(
      padding: const EdgeInsets.all(24),
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Số lượng tài sản",
            style: AppStyle.headingXl.copyWith(color: const Color(0xFF201B51)),
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
                Text("Khoa/Phòng", style: AppStyle.headingBs),
                Text("Tổng nguyên giá", style: AppStyle.headingBs),
              ],
            ),
          ),
          12.height,
          const Divider(height: 1, color: AppColors.grey20),
          SizedBox(
            height: 240, // Height for about 5 items
            child: RawScrollbar(
              controller: _scrollController,
              thickness: 4,
              radius: const Radius.circular(3),
              thumbColor: AppColors.grey60.withOpacity(0.5),
              thumbVisibility: true,
              child: ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 10, // Mocking more items to show scroll
                separatorBuilder:
                    (context, index) =>
                        const Divider(height: 1, color: AppColors.grey20),
                itemBuilder: (context, index) {
                  final titles = [
                    "Khoa Dược",
                    "Khoa Nhi",
                    "Khoa Sản",
                    "Khoa Cấp cứu",
                    "Khoa Nội",
                    "Khoa Ngoại",
                    "Khoa Mắt",
                    "Khoa Tai Mũi Họng",
                    "Khoa Răng Hàm Mặt",
                    "Khoa Chẩn đoán hình ảnh",
                  ];
                  return _buildListItem(titles[index % titles.length]);
                },
              ),
            ),
          ),
        ],
      ),
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

  Widget _buildListItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(title, style: AppStyle.bodyBsRegular)),
          Text("123.456.789 đ", style: AppStyle.bodyBsSemiBold),
        ],
      ),
    );
  }

  Widget _buildDepreciationRateSection() {
    return BaseContainer(
      padding: const EdgeInsets.all(24),
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tỷ lệ hao mòn tài sản",
            style: AppStyle.headingXl.copyWith(color: const Color(0xFF201B51)),
          ),
          12.height,
          const Divider(color: AppColors.grey20, height: 1),
          12.height,
          _buildProgressBar(
            label: "Hao mòn 0-30%",
            color: AppColors.green60,
            percent: 0.85,
            labelColor: AppColors.green60,
          ),
          const Divider(color: AppColors.grey20, height: 24),
          _buildProgressBar(
            label: "Hao mòn 31-60%",
            color: AppColors.blue60,
            percent: 0.85,
            labelColor: AppColors.blue60,
          ),
          const Divider(color: AppColors.grey20, height: 24),
          _buildProgressBar(
            label: "Hao mòn 61-80%",
            color: AppColors.orange60,
            percent: 0.85,
            labelColor: AppColors.orange60,
          ),
          const Divider(color: AppColors.grey20, height: 24),
          _buildProgressBar(
            label: "Hao mòn 81-100%",
            color: AppColors.red60,
            percent: 0.85,
            labelColor: AppColors.red60,
          ),
        ],
      ),
    );
  }

  Widget _buildAssetStatusSection() {
    return BaseContainer(
      padding: const EdgeInsets.all(24),
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tỷ lệ trạng thái tài sản",
            style: AppStyle.headingXl.copyWith(color: const Color(0xFF201B51)),
          ),
          12.height,
          const Divider(color: AppColors.grey20, height: 1),
          12.height,
          _buildProgressBar(
            label: "Chưa nhập",
            color: const Color(0xFF7E52FF),
            percent: 0.85,
            price: "123.345.456 đ",
          ),
          const Divider(color: AppColors.grey20, height: 24),
          _buildProgressBar(
            label: "Nhàn rỗi",
            color: const Color(0xFF7E52FF),
            percent: 0.85,
            price: "123.345.456 đ",
          ),
          const Divider(color: AppColors.grey20, height: 24),
          _buildProgressBar(
            label: "Đang sử dụng",
            color: const Color(0xFF7E52FF),
            percent: 0.50,
            price: "123.345.456 đ",
          ),
          const Divider(color: AppColors.grey20, height: 24),
          _buildProgressBar(
            label: "Đang sửa chữa",
            color: const Color(0xFF7E52FF),
            percent: 0.85,
            price: "123.345.456 đ",
          ),
          const Divider(color: AppColors.grey20, height: 24),
          _buildProgressBar(
            label: "Đang bảo dưỡng",
            color: const Color(0xFF7E52FF),
            percent: 0.20,
            price: "123.345.456 đ",
          ),
          const Divider(color: AppColors.grey20, height: 24),
          _buildProgressBar(
            label: "Chờ thanh lý",
            color: const Color(0xFF7E52FF),
            percent: 0.85,
            price: "123.345.456 đ",
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar({
    required String label,
    required Color color,
    required double percent,
    String? price,
    Color? labelColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppStyle.bodyMdSemiBold.copyWith(
                color: labelColor ?? AppColors.grey60,
              ),
            ),
            Text("3.456", style: AppStyle.headingXl),
          ],
        ),
        if (price != null) ...[
          4.height,
          BaseContainer(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            borderRadius: 8,
            color: AppColors.grey20.withOpacity(0.5),
            child: Text(
              price,
              style: AppStyle.bodySmRegular.copyWith(
                color: AppColors.text_tertiary,
              ),
            ),
          ),
        ],
        12.height,
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
            12.width,
            BaseContainer(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              borderRadius: 20,
              color: AppColors.grey20.withOpacity(0.5),
              child: Text(
                "${(percent * 100).toInt()}%",
                style: AppStyle.bodySmSemiBold.copyWith(
                  color: AppColors.text_tertiary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
