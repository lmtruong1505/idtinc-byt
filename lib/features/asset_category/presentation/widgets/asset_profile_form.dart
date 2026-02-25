import 'package:bpg_retail/core/configs/app_style/init_app_style.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:bpg_retail/core/utilities/converts.dart';
import 'package:bpg_retail/core/widgets/textfield/input_column.dart';
import 'package:bpg_retail/core/widgets/common_date_picker.dart';
import 'package:bpg_retail/features/asset_category/data/bloc/asset_form_delegate.dart';
import 'package:bpg_retail/features/asset_category/data/bloc/create_asset_state.dart';
import 'package:bpg_retail/features/asset_category/presentation/widgets/asset_image_picker_widget.dart';
import 'package:bpg_retail/features/asset_category/presentation/widgets/depreciation_method_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AssetProfileForm extends StatelessWidget {
  final AssetDetail asset;
  final int? attachedIndex;
  final VoidCallback? onScrollToTop;
  final AssetFormDelegate delegate;

  const AssetProfileForm({
    super.key,
    required this.asset,
    required this.delegate,
    this.attachedIndex,
    this.onScrollToTop,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = delegate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Image Picker ──
        AssetImagePickerWidget(
          imagePath: asset.imagePath,
          onImagePicked:
              (path) => cubit.setImage(path, attachedIndex: attachedIndex),
          onImageRemoved: () => cubit.removeImage(attachedIndex: attachedIndex),
        ),
        Divider(height: 1, color: AppColors.border_tertiary),
        16.height,

        // ── Tên tài sản * ──
        InputColumn(
          label: 'Tên tài sản',
          isRequired: true,
          hintText: 'Nhập tên thiết bị',
          initialValue: asset.assetName,
          onChanged:
              (v) => cubit.updateAssetName(v, attachedIndex: attachedIndex),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        12.height,

        // ── Mã tài sản ──
        InputColumn(
          label: 'Mã tài sản',
          hintText: 'Nhập mã thiết bị',
          initialValue: asset.assetCode,
          onChanged:
              (v) => cubit.updateAssetCode(v, attachedIndex: attachedIndex),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        12.height,

        // ── Loại tài sản (Dropdown) ──
        InputColumn(
          label: 'Loại tài sản',
          hintText: 'Chọn',
          readOnly: true,
          onTap: () {
            // TODO: Mở bottom sheet chọn loại tài sản
          },
          suffixIcon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.grey80,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        12.height,

        // ── Đơn vị tính & Seri ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: InputColumn(
                  label: 'Đơn vị tính',
                  hintText: 'Nhập',
                  initialValue: asset.unit,
                  onChanged:
                      (v) => cubit.updateUnit(v, attachedIndex: attachedIndex),
                  padding: EdgeInsets.zero,
                ),
              ),
              12.width,
              Expanded(
                child: InputColumn(
                  label: 'Seri',
                  hintText: 'Nhập',
                  initialValue: asset.serial,
                  onChanged:
                      (v) =>
                          cubit.updateSerial(v, attachedIndex: attachedIndex),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
        12.height,

        // ── Model & Nước sản xuất ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: InputColumn(
                  label: 'Model',
                  hintText: 'Nhập',
                  initialValue: asset.model,
                  onChanged:
                      (v) => cubit.updateModel(v, attachedIndex: attachedIndex),
                  padding: EdgeInsets.zero,
                ),
              ),
              12.width,
              Expanded(
                child: InputColumn(
                  label: 'Nước sản xuất',
                  hintText: 'Nhập',
                  initialValue: asset.origin,
                  onChanged:
                      (v) =>
                          cubit.updateOrigin(v, attachedIndex: attachedIndex),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
        12.height,

        // ── Hãng sản xuất & Ngày sản xuất ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: InputColumn(
                  label: 'Hãng sản xuất',
                  hintText: 'Nhập',
                  initialValue: asset.manufacturer,
                  onChanged:
                      (v) => cubit.updateManufacturer(
                        v,
                        attachedIndex: attachedIndex,
                      ),
                  padding: EdgeInsets.zero,
                ),
              ),
              12.width,
              Expanded(
                child: CommonDatePicker(
                  label: 'Ngày sản xuất',
                  initialValue: asset.manufacturingDate,
                  onConfirm: (date) {
                    cubit.updateManufacturingDate(
                      convertDateYYYYMMDD(date),
                      attachedIndex: attachedIndex,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        24.height,

        // ── Depreciation Method ──
        DepreciationMethodWidget(
          method: asset.depreciationMethod,
          period: asset.depreciationPeriod,
          onMethodChanged:
              (m) =>
                  cubit.setDepreciationMethod(m, attachedIndex: attachedIndex),
          onPeriodChanged:
              (p) =>
                  cubit.setDepreciationPeriod(p, attachedIndex: attachedIndex),
        ),
        24.height,

        // ── Nguyên giá ──
        InputColumn2(
          textSuffix: 'đ',
          label: 'Nguyên giá',
          hintText: 'Nhập',
          initialValue: asset.originalPrice,
          textInputType: TextInputType.number,
          onChanged:
              (v) => cubit.updateOriginalPrice(v, attachedIndex: attachedIndex),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        12.height,

        // ── Ngày bắt đầu sử dụng ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CommonDatePicker(
            label: 'Ngày bắt đầu sử dụng',
            initialValue: asset.usageStartDate,
            onConfirm: (date) {
              cubit.updateUsageStartDate(
                convertDateYYYYMMDD(date),
                attachedIndex: attachedIndex,
              );
            },
          ),
        ),
        12.height,

        // ── Thời gian tính khấu hao ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: InputColumn2(
                  textSuffix: 'Năm',
                  label: 'Thời gian tính khấu hao',
                  hintText: 'Nhập',
                  initialValue: asset.depreciationDuration,
                  textInputType: TextInputType.number,
                  onChanged:
                      (v) => cubit.updateDepreciationDuration(
                        v,
                        attachedIndex: attachedIndex,
                      ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
        32.height,

        if (onScrollToTop != null)
          // ── Scroll to top ──
          Center(
            child: GestureDetector(
              onTap: onScrollToTop,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.arrow_upward,
                    color: AppColors.main,
                    size: 16,
                  ),
                  4.width,
                  Text(
                    'Lên đầu trang',
                    style: AppTypography.p5.copyWith(
                      color: AppColors.main,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
