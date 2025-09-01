import 'package:flutter/material.dart';
import '../indicators/rsi_calculator.dart';

class RSIPainter extends CustomPainter {
  final List<RSIData> rsiData;
  final Color lineColor;
  final Color overboughtColor;
  final Color oversoldColor;
  final Color fillColor;
  final double strokeWidth;
  final double overboughtLevel;
  final double oversoldLevel;
  final bool showLevels;
  final bool showFill;

  RSIPainter({
    required this.rsiData,
    this.lineColor = Colors.purple,
    this.overboughtColor = Colors.red,
    this.oversoldColor = Colors.green,
    this.fillColor = Colors.purple,
    this.strokeWidth = 1.5,
    this.overboughtLevel = 70.0,
    this.oversoldLevel = 30.0,
    this.showLevels = true,
    this.showFill = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (rsiData.isEmpty) return;

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final levelPaint = Paint()
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = fillColor.withAlpha(50)
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();
    
    final double stepX = size.width / (rsiData.length - 1);
    
    if (showLevels) {
      final double overboughtY = _getRSIY(overboughtLevel, size.height);
      final double oversoldY = _getRSIY(oversoldLevel, size.height);
      final double midY = _getRSIY(50.0, size.height);
      
      levelPaint.color = overboughtColor.withAlpha(100);
      canvas.drawLine(
        Offset(0, overboughtY),
        Offset(size.width, overboughtY),
        levelPaint,
      );
      
      levelPaint.color = oversoldColor.withAlpha(100);
      canvas.drawLine(
        Offset(0, oversoldY),
        Offset(size.width, oversoldY),
        levelPaint,
      );
      
      levelPaint.color = Colors.grey.withAlpha(100);
      canvas.drawLine(
        Offset(0, midY),
        Offset(size.width, midY),
        levelPaint,
      );
    }

    for (int i = 0; i < rsiData.length; i++) {
      final double x = i * stepX;
      final double y = _getRSIY(rsiData[i].rsi, size.height);
      
      if (i == 0) {
        path.moveTo(x, y);
        if (showFill) {
          fillPath.moveTo(x, size.height);
          fillPath.lineTo(x, y);
        }
      } else {
        path.lineTo(x, y);
        if (showFill) fillPath.lineTo(x, y);
      }
    }

    if (showFill && rsiData.isNotEmpty) {
      final double lastX = (rsiData.length - 1) * stepX;
      fillPath.lineTo(lastX, size.height);
      fillPath.close();
      canvas.drawPath(fillPath, fillPaint);
    }

    canvas.drawPath(path, paint);

    _drawSignalAreas(canvas, size, stepX);
  }

  void _drawSignalAreas(Canvas canvas, Size size, double stepX) {
    final overboughtPaint = Paint()
      ..color = overboughtColor.withAlpha(30)
      ..style = PaintingStyle.fill;
    
    final oversoldPaint = Paint()
      ..color = oversoldColor.withAlpha(30)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < rsiData.length - 1; i++) {
      final double x1 = i * stepX;
      final double x2 = (i + 1) * stepX;
      
      if (rsiData[i].isOverbought) {
        final rect = Rect.fromLTWH(
          x1, 
          0, 
          x2 - x1, 
          _getRSIY(overboughtLevel, size.height),
        );
        canvas.drawRect(rect, overboughtPaint);
      }
      
      if (rsiData[i].isOversold) {
        final rect = Rect.fromLTWH(
          x1, 
          _getRSIY(oversoldLevel, size.height), 
          x2 - x1, 
          size.height - _getRSIY(oversoldLevel, size.height),
        );
        canvas.drawRect(rect, oversoldPaint);
      }
    }
  }

  double _getRSIY(double rsi, double height) {
    return height - ((rsi / 100.0) * height);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! RSIPainter ||
        oldDelegate.rsiData != rsiData ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}