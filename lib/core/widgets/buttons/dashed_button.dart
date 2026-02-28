import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:flutter/material.dart';

class DashedButton extends StatelessWidget {
  final String title;
  final Widget? icon;
  final VoidCallback? onTap;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double height;

  const DashedButton({
    super.key,
    required this.title,
    this.icon,
    this.onTap,
    this.color,
    this.textColor,
    this.width,
    this.height = 40,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: CustomPaint(
        painter: _DashedRectPainter(
          color: color ?? AppColors.grey79,
          strokeWidth: 1,
          gap: 4,
          dashLength: 4,
          radius: 8,
        ),
        child: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: AppTypography.p6.copyWith(
                  color: textColor ?? AppColors.grey79,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (icon != null) ...[8.width, icon!],
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dashLength;
  final double radius;

  _DashedRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
    required this.dashLength,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

    final path =
        Path()..addRRect(
          RRect.fromLTRBR(
            0,
            0,
            size.width,
            size.height,
            Radius.circular(radius),
          ),
        );

    final dashedPath = Path();
    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        dashedPath.addPath(
          metric.extractPath(distance, distance + dashLength),
          Offset.zero,
        );
        distance += dashLength + gap;
      }
    }
    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
