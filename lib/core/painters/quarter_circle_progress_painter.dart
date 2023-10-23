import 'package:flutter/material.dart';
import 'dart:math';

enum QuarterCircleProgress {
  empty,
  quarter,
  twoquarter,
  threequarter,
  full,
}

class QuarterCircleProgressPainter extends CustomPainter {
  final QuarterCircleProgress quarterCircleProgress;
  final Color color;

  QuarterCircleProgressPainter({
    required this.quarterCircleProgress,
    required this.color,
    super.repaint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        height: size.height,
        width: size.width,
      ),
      3 * pi / 2,
      quarterCircleProgress == QuarterCircleProgress.empty
          ? 0
          : quarterCircleProgress == QuarterCircleProgress.quarter
              ? pi / 2
              : quarterCircleProgress == QuarterCircleProgress.twoquarter
                  ? pi
                  : quarterCircleProgress == QuarterCircleProgress.threequarter
                      ? 3 * pi / 2
                      : 2 * pi,
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
