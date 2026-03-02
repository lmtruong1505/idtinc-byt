import 'package:flutter/material.dart';

class DashedLinePainter extends CustomPainter {
  final Axis axis;
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  DashedLinePainter({
    required this.axis,
    this.color = Colors.grey,
    this.strokeWidth = 2,
    this.dashWidth = 6,
    this.dashSpace = 6,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    if (axis == Axis.vertical) {
      double startY = 0;
      while (startY < size.height) {
        canvas.drawLine(
          Offset(size.width / 2, startY),
          Offset(size.width / 2, startY + dashWidth),
          paint,
        );
        startY += dashWidth + dashSpace;
      }
    } else {
      double startX = 0;
      while (startX < size.width) {
        canvas.drawLine(
          Offset(startX, size.height / 2),
          Offset(startX + dashWidth, size.height / 2),
          paint,
        );
        startX += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant DashedLinePainter oldDelegate) =>
      color != oldDelegate.color ||
      strokeWidth != oldDelegate.strokeWidth ||
      axis != oldDelegate.axis;
}

class DashedLineWidget extends StatelessWidget {
  final Axis axis;
  final double length;
  final Color color;
  final double strokeWidth;

  const DashedLineWidget({
    super.key,
    required this.axis,
    required this.length,
    this.color = Colors.grey,
    this.strokeWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size:
          axis == Axis.vertical
              ? Size(strokeWidth, length)
              : Size(length, strokeWidth),
      painter: DashedLinePainter(
        axis: axis,
        color: color,
        strokeWidth: strokeWidth,
      ),
    );
  }
}
