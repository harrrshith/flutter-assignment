import 'package:flutter/material.dart';

class RSIAxisPainter extends CustomPainter {
  final Color textColor;
  final double fontSize;
  final double overboughtLevel;
  final double oversoldLevel;

  RSIAxisPainter({
    this.textColor = Colors.black54,
    this.fontSize = 10.0,
    this.overboughtLevel = 70.0,
    this.oversoldLevel = 30.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    final levels = [100.0, overboughtLevel, 50.0, oversoldLevel, 0.0];
    
    for (final level in levels) {
      final y = size.height - ((level / 100.0) * size.height);
      
      final tickPaint = Paint()
        ..color = textColor.withAlpha(100)
        ..strokeWidth = 1.0;
      
      canvas.drawLine(
        Offset(0, y),
        Offset(5, y),
        tickPaint,
      );
      
      final color = _getLevelColor(level);
      textPainter.text = TextSpan(
        text: level.toInt().toString(),
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: _isImportantLevel(level) ? FontWeight.bold : FontWeight.normal,
        ),
      );
      
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(8, y - (textPainter.height / 2)),
      );
    }
  }

  Color _getLevelColor(double level) {
    if (level >= overboughtLevel) return Colors.red.shade600;
    if (level <= oversoldLevel) return Colors.green.shade600;
    if (level == 50.0) return Colors.grey.shade700;
    return textColor;
  }

  bool _isImportantLevel(double level) {
    return level == overboughtLevel || level == oversoldLevel || level == 50.0;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! RSIAxisPainter ||
        oldDelegate.textColor != textColor ||
        oldDelegate.fontSize != fontSize;
  }
}