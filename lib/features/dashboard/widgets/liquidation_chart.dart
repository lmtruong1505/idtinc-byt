import 'dart:math';

import 'package:bpg_retail/core/configs/app_style/init_app_style.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:bpg_retail/core/widgets/base_container.dart';
import 'package:flutter/material.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/core/ext/ext_num.dart';
import 'package:bpg_retail/features/dashboard/presentation/bloc/asset_overview_cubit.dart';
import 'package:bpg_retail/features/dashboard/presentation/bloc/asset_overview_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LiquidationChartWidget extends StatelessWidget {
  const LiquidationChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssetOverviewCubit, AssetOverviewState>(
      builder: (context, state) {
        String soLuong = "---";
        String giaTri = "--- đ";

        String slConKhauHao = "---";
        String percentConKhauHao = "--%";
        double valConKhauHao = 50.0; // dummy default for equal pie slices

        String slHetKhauHao = "---";
        String percentHetKhauHao = "--%";
        double valHetKhauHao = 50.0; // dummy default for equal pie slices

        if (state.status == CubitStatus.success && state.data != null) {
          soLuong = (state.data!.tongSoLuongThanhLy ?? 0).formatNumber;
          giaTri = "${(state.data!.tongGiaTriThanhLy ?? 0).formatNumber} đ";

          slConKhauHao =
              (state.data!.soLuongThanhLyConKhauHao ?? 0).formatNumber;
          percentConKhauHao =
              "${(state.data!.tiLeSoLuongThanhLyConKhauHao ?? 0).formatNumber}%";
          valConKhauHao = state.data!.tiLeSoLuongThanhLyConKhauHao ?? 0;

          slHetKhauHao =
              (state.data!.soLuongThanhLyHetKhauHao ?? 0).formatNumber;
          percentHetKhauHao =
              "${(state.data!.tiLeSoLuongThanhLyHetKhauHao ?? 0).formatNumber}%";
          valHetKhauHao = state.data!.tiLeSoLuongThanhLyHetKhauHao ?? 0;

          if (valConKhauHao == 0 && valHetKhauHao == 0) {
            valConKhauHao = 50.0;
            valHetKhauHao = 50.0;
          }
        }

        return BaseContainer(
          padding: const EdgeInsets.all(24),
          borderRadius: 24,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Số lượng đã thanh lý",
                        style: AppStyle.bodySmRegular.copyWith(
                          color: AppColors.text_quaternary,
                        ),
                      ),
                      4.height,
                      Text(soLuong, style: AppStyle.headingMd),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Giá trị thanh lý",
                        style: AppStyle.bodySmRegular.copyWith(
                          color: AppColors.text_quaternary,
                        ),
                      ),
                      4.height,
                      Text(giaTri, style: AppStyle.headingMd),
                    ],
                  ),
                ],
              ),
              16.height,
              const Divider(color: AppColors.border_tertiary, thickness: 1),
              16.height,
              Center(
                child: SizedBox(
                  width: 180,
                  height: 180,
                  child: CustomPaint(
                    painter: PieChartPainter(
                      sections: [
                        PieSection(
                          value: valHetKhauHao > 0 ? valHetKhauHao : 0.001,
                          color: AppColors.blue70,
                        ),
                        PieSection(
                          value: valConKhauHao > 0 ? valConKhauHao : 0.001,
                          color: AppColors.blue30,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              24.height,
              BaseContainer(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                borderRadius: 24,
                color: AppColors.main.withOpacity(0.8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "Thanh lý khi còn\nkhấu hao",
                            style: AppStyle.bodySmRegular.copyWith(
                              color: AppColors.whiteAlpha70,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                          8.height,
                          Text(
                            "$slConKhauHao ($percentConKhauHao)",
                            style: AppStyle.headingMd.copyWith(
                              color: AppColors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: AppColors.whiteAlpha20,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "Thanh lý khi hết\nkhấu hao",
                            style: AppStyle.bodySmRegular.copyWith(
                              color: AppColors.whiteAlpha70,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                          8.height,
                          Text(
                            "$slHetKhauHao ($percentHetKhauHao)",
                            style: AppStyle.headingMd.copyWith(
                              color: AppColors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PieSection {
  final double value;
  final Color color;
  PieSection({required this.value, required this.color});
}

class PieChartPainter extends CustomPainter {
  final List<PieSection> sections;

  PieChartPainter({required this.sections});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);

    double startAngle = -pi / 2; // Start from the top
    final total = sections.fold(0.0, (sum, item) => sum + item.value);

    for (var section in sections) {
      final sweepAngle = (section.value / total) * 2 * pi;
      final paint =
          Paint()
            ..color = section.color
            ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
