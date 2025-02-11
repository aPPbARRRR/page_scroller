import 'dart:math';

import 'package:flutter/material.dart';

class BarChildWidget extends StatelessWidget {
  const BarChildWidget({super.key, required this.size, required this.color});

  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: StarPainter(color: color),
      size: Size(size, size),
    );
  }
}

class StarPainter extends CustomPainter {
  StarPainter({required this.color});

  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;

    for (int i = 0; i < 5; i++) {
      final outerX = centerX + radius * cos((i * 72 - 90) * 3.14159 / 180);
      final outerY = centerY + radius * sin((i * 72 - 90) * 3.14159 / 180);

      final innerX =
          centerX + radius * 0.4 * cos(((i * 72 + 36) - 90) * 3.14159 / 180);
      final innerY =
          centerY + radius * 0.4 * sin(((i * 72 + 36) - 90) * 3.14159 / 180);

      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      path.lineTo(innerX, innerY);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
