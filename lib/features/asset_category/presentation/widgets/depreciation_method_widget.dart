import 'package:bpg_retail/core/configs/app_style/init_app_style.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:bpg_retail/features/asset_category/data/bloc/create_asset_state.dart';
import 'package:flutter/material.dart';

class DepreciationMethodWidget extends StatelessWidget {
  final DepreciationMethod method;
  final DepreciationPeriod period;
  final ValueChanged<DepreciationMethod> onMethodChanged;
  final ValueChanged<DepreciationPeriod> onPeriodChanged;

  const DepreciationMethodWidget({
    super.key,
    required this.method,
    required this.period,
    required this.onMethodChanged,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Title with lines matching screenshot ──
        Row(
          children: [
            Expanded(child: Divider(color: AppColors.border_tertiary)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Phương pháp tính khấu hao',
                style: AppTypography.p6.copyWith(
                  color: AppColors.text_tertiary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Expanded(child: Divider(color: AppColors.border_tertiary)),
          ],
        ),
        24.height,

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Theo thời gian ──
              _buildMethodOption(
                title: 'Theo thời gian',
                description:
                    'Khấu hao của tài sản sẽ được tính theo thời gian thực tế sử dụng thực tế',
                value: DepreciationMethod.byTime,
                isSelected: method == DepreciationMethod.byTime,
                enabled: true,
              ),

              // ── Sub-options (chỉ hiện khi chọn "Theo thời gian") ──
              if (method == DepreciationMethod.byTime) ...[
                12.height,
                Padding(
                  padding: const EdgeInsets.only(left: 44),
                  child: Column(
                    children: [
                      _buildPeriodOption(
                        'Theo năm',
                        DepreciationPeriod.yearly,
                        enabled: true,
                      ),
                      12.height,
                      _buildPeriodOption(
                        'Theo tháng',
                        DepreciationPeriod.monthly,
                        enabled: false,
                      ),
                      12.height,
                      _buildPeriodOption(
                        'Theo ngày',
                        DepreciationPeriod.daily,
                        enabled: false,
                      ),
                    ],
                  ),
                ),
              ],

              20.height,
              Divider(color: AppColors.border_tertiary),
              20.height,

              // ── Theo công suất sử dụng ──
              _buildMethodOption(
                title: 'Theo công suất sử dụng',
                description:
                    'Khấu hao của tài sản sẽ được tính theo công suất sử dụng thực tế',
                value: DepreciationMethod.byUsage,
                isSelected: method == DepreciationMethod.byUsage,
                enabled: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMethodOption({
    required String title,
    required String description,
    required DepreciationMethod value,
    required bool isSelected,
    bool enabled = true,
  }) {
    return GestureDetector(
      onTap: enabled ? () => onMethodChanged(value) : null,
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _radioIcon(isSelected, enabled: enabled),
          12.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.p5.copyWith(
                    fontWeight: FontWeight.w600,
                    color: enabled ? AppColors.black : AppColors.text_disable,
                  ),
                ),
                4.height,
                Text(
                  description,
                  style: AppTypography.p6.copyWith(
                    color: enabled ? AppColors.grey80 : AppColors.text_disable,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodOption(
    String label,
    DepreciationPeriod value, {
    bool enabled = true,
  }) {
    final isSelected = period == value;
    return GestureDetector(
      onTap: enabled ? () => onPeriodChanged(value) : null,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          _radioIcon(isSelected, size: 18, enabled: enabled),
          12.width,
          Text(
            label,
            style: AppTypography.p5.copyWith(
              color: enabled ? AppColors.black : AppColors.text_disable,
            ),
          ),
        ],
      ),
    );
  }

  Widget _radioIcon(bool isSelected, {double size = 18, bool enabled = true}) {
    final color = enabled ? AppColors.main : AppColors.text_disable;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? color : AppColors.grey30,
          width: 1.5,
        ),
      ),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? color : Colors.transparent,
            border:
                isSelected ? Border.all(color: Colors.white, width: 2.5) : null,
          ),
        ),
      ),
    );
  }
}
