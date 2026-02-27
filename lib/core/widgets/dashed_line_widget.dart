import 'package:flutter/material.dart';

class DashedLinePainter extends CustomPainter {
  final Axis axis; // Thêm tham số hướng
  DashedLinePainter({required this.axis});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = Colors.grey
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    const double dashWidth = 6;
    const double dashSpace = 6;

    if (axis == Axis.vertical) {
      // Vẽ dashline theo chiều dọc
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
      // Vẽ dashline theo chiều ngang
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DashedLineWidget extends StatelessWidget {
  final Axis axis;
  final double length;

  const DashedLineWidget({super.key, required this.axis, required this.length});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size:
          axis == Axis.vertical
              ? Size(2, length) // Chiều dọc: rộng 2px, cao = length
              : Size(length, 2), // Kích thước đường dash
      painter: DashedLinePainter(axis: axis),
    );
  }
}
