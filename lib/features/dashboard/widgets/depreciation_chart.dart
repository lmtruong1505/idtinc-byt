import 'dart:math';

import 'package:tasa/core/configs/app_style/init_app_style.dart';
import 'package:tasa/core/constants/typography.dart';
import 'package:tasa/core/extension/spacing_extension.dart';
import 'package:tasa/core/widgets/base_container.dart';
import 'package:flutter/material.dart';
import 'package:tasa/core/utilities/enum.dart';
import 'package:tasa/core/ext/ext_num.dart';
import 'package:tasa/features/dashboard/presentation/bloc/asset_overview_cubit.dart';
import 'package:tasa/features/dashboard/presentation/bloc/asset_overview_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DepreciationChartWidget extends StatelessWidget {
  const DepreciationChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssetOverviewCubit, AssetOverviewState>(
      builder: (context, state) {
        String haoMon = "--- đ";
        String conLai = "--- đ";
        double percentage = 0.0;
        String percentStr = "0%";
        String percentConLaiStr = "100%";

        if (state.status == CubitStatus.success && state.data != null) {
          haoMon = "${(state.data!.tongGiaTriHaoMon ?? 0).formatNumber} đ";
          conLai =
              "${(state.data!.tongGiaTriHaoMonConLai ?? 0).formatNumber} đ";

          percentage = (state.data!.tiLeHaoMon ?? 0) / 100;
          if (percentage > 1.0) percentage = 1.0;
          if (percentage < 0.0) percentage = 0.0;

          percentStr = "${(state.data!.tiLeHaoMon ?? 0).formatPercent()}%";
          percentConLaiStr =
              "${(state.data!.tiLeHaoMonConLai ?? 0).formatPercent()}%";
        }

        return BaseContainer(
          padding: const EdgeInsets.all(16),
          borderRadius: 16,
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
                        "Tổng hao mòn",
                        style: AppTypography.p7.copyWith(
                          color: AppColors.text_tertiary,
                        ),
                      ),
                      4.height,
                      Text(haoMon, style: AppTypography.h5),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Còn lại",
                        style: AppTypography.p7.copyWith(
                          color: AppColors.red60,
                        ),
                      ),
                      4.height,
                      Text(conLai, style: AppTypography.h5),
                    ],
                  ),
                ],
              ),
              24.height,
              const Divider(height: 1, color: AppColors.grey10),
              12.height,
              SizedBox(
                height: 150,
                width: double.infinity,
                child: CustomPaint(
                  painter: GaugeChartPainter(percentage: percentage),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        percentStr,
                        style: AppTypography.h2.copyWith(
                          color: const Color(0xff22215B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      24.width,
                      Text(
                        percentConLaiStr,
                        style: AppTypography.h2.copyWith(
                          color: const Color(0xff88879C),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class GaugeChartPainter extends CustomPainter {
  final double percentage;

  GaugeChartPainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = min(size.width / 2, size.height) - 10;
    const strokeWidth = 20.0;

    final paintBg =
        Paint()
          ..color = AppColors.blue30
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    final paintValue =
        Paint()
          ..color = AppColors.blue70
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi,
      false,
      paintBg,
    );

    final sweepAngle = pi * percentage;

    paintValue.color = AppColors.blue70;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      sweepAngle,
      false,
      paintValue,
    );

    final knobAngle = pi + sweepAngle;
    final knobCenter = Offset(
      center.dx + radius * cos(knobAngle),
      center.dy + radius * sin(knobAngle),
    );

    final knobPaint = Paint()..color = AppColors.blue70;
    canvas.drawCircle(knobCenter, strokeWidth / 1.5, knobPaint);

    canvas.drawCircle(
      knobCenter,
      strokeWidth / 3,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
