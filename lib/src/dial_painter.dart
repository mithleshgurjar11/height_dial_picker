import 'dart:math';
import 'package:flutter/material.dart';

class DialPainter extends CustomPainter {
  final double angle;
  final int min;
  final int max;
  final String unit;

  final Color smallTickColor;
  final Color bigTickColor;
  final Color centerLineColor;
  final Color selectedTickColor;
  final Color labelTextColor;

  DialPainter({
    required this.angle,
    required this.min,
    required this.max,
    required this.unit,
    required this.smallTickColor,
    required this.bigTickColor,
    required this.centerLineColor,
    required this.selectedTickColor,
    required this.labelTextColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint bigTickPaint = Paint()
      ..color = bigTickColor
      ..strokeWidth = 2;

    final Paint smallTickPaint = Paint()
      ..color = smallTickColor
      ..strokeWidth = 1;

    final Paint selectedPaint = Paint()
      ..color = selectedTickColor
      ..strokeWidth = 3;

    final Paint horizontalLinePaint = Paint()
      ..color = centerLineColor
      ..strokeWidth = 0.5;

    final double lineY = size.height * 0.4;
    final double padding = 16;
    final double availableWidth = size.width - 2 * padding;
    final int totalInches = (max - min) * 12;
    final double spacePerInch = availableWidth / totalInches;

    final double tickHeightSmall = 20;
    final double tickHeightBig = 40;

    final progress = angle / pi;
    final currentInches = (min * 12 + (max * 12 - min * 12) * progress).round();
    final int currentFeet = currentInches ~/ 12;

    for (int i = 0; i <= totalInches; i++) {
      final totalInchesValue = min * 12 + i;
      final feet = (totalInchesValue / 12).floor();
      final inches = totalInchesValue % 12;

      final double x = padding + i * spacePerInch;
      final bool isBig = inches == 0;

      final Paint paint = (totalInchesValue == currentInches)
          ? selectedPaint
          : (isBig ? bigTickPaint : smallTickPaint);

      final double tickTop = lineY - (isBig ? tickHeightBig : tickHeightSmall);
      final double tickBottom = lineY + (isBig ? tickHeightBig : tickHeightSmall);

      canvas.drawLine(Offset(x, tickTop), Offset(x, tickBottom), paint);

      if (isBig) {
        final bool isSelected = feet == currentFeet;

        final labelText = unit == 'ft'
            ? '$feet'
            : '${(feet * 12 * 2.54).round()}';

        final textPainter = TextPainter(
          text: TextSpan(
            text: labelText,
            style: TextStyle(
              fontSize: isSelected ? 44 : 14,
              fontWeight: FontWeight.w700,
              color: labelTextColor,
            ),
          ),
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, tickBottom + 8),
        );
      }
    }

    for (int f = min; f < max; f++) {
      final double startX = padding + (f - min) * 12 * spacePerInch;
      final double endX = startX + 12 * spacePerInch;

      canvas.drawLine(
        Offset(startX, lineY),
        Offset(endX, lineY),
        horizontalLinePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}