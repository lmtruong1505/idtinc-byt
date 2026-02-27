import 'package:bpg_retail/core/configs/app_style/init_app_style.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:bpg_retail/core/ext/ext_num.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/core/widgets/base_container.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/features/dashboard/presentation/bloc/depreciation_rate_cubit.dart';
import 'package:bpg_retail/features/dashboard/presentation/bloc/depreciation_rate_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DepreciationRateChartWidget extends StatelessWidget {
  const DepreciationRateChartWidget({super.key});

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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Text(
              "Tỷ lệ hao mòn tài sản",
              style: AppTypography.h3.copyWith(color: const Color(0xff22215B)),
            ),
          ),
          const Divider(height: 1, color: AppColors.grey10),
          BlocBuilder<DepreciationRateCubit, DepreciationRateState>(
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

              final items = state.data;

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
                padding: const EdgeInsets.all(24),
                separatorBuilder:
                    (context, index) =>
                        const Divider(height: 32, color: AppColors.grey20),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final color = _parseColor(item.color);
                  final percentNormalized =
                      (item.percent ?? 0).toDouble() / 100;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.label ?? "",
                              style: AppTypography.p4.copyWith(
                                color: const Color(0xff88879C),
                              ),
                            ),
                            12.height,
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: percentNormalized,
                                backgroundColor: AppColors.grey10,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  color,
                                ),
                                minHeight: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      24.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${item.value ?? 0}",
                            style: AppTypography.h2.copyWith(
                              color: const Color(0xff22215B),
                            ),
                          ),
                          8.height,
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.grey10.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "${(item.percent ?? 0).formatPercent()}%",
                              style: AppTypography.p9.copyWith(
                                color: AppColors.text_tertiary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
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
}
