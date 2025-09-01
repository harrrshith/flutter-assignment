import 'package:flutter/material.dart';
import '../models/candle_chart_data.dart';

class InteractiveChartPainter extends CustomPainter {
  final List<CandleChartData> data;
  final double maxPrice;
  final double minPrice;
  final Color bullishColor;
  final Color bearishColor;
  final double candleWidth;
  final Offset? touchPoint;
  final int? selectedIndex;
  final Color crosshairColor;
  final bool showCrosshair;

  InteractiveChartPainter({
    required this.data,
    required this.maxPrice,
    required this.minPrice,
    required this.bullishColor,
    required this.bearishColor,
    required this.candleWidth,
    this.touchPoint,
    this.selectedIndex,
    this.crosshairColor = Colors.grey,
    this.showCrosshair = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final priceRange = maxPrice - minPrice;
    final candleSpacing = size.width / data.length;
    
    // Draw candlesticks
    for (int i = 0; i < data.length; i++) {
      final candle = data[i];
      final x = i * candleSpacing + candleSpacing / 2;
      
      final openY = size.height - ((candle.open - minPrice) / priceRange) * size.height;
      final highY = size.height - ((candle.high - minPrice) / priceRange) * size.height;
      final lowY = size.height - ((candle.low - minPrice) / priceRange) * size.height;
      final closeY = size.height - ((candle.close - minPrice) / priceRange) * size.height;
      
      final isBullish = candle.isBullish;
      final candleColor = isBullish ? bullishColor : bearishColor;
      final isSelected = selectedIndex == i;
      
      // Draw wick (high-low line)
      final wickPaint = Paint()
        ..color = isSelected ? candleColor.withAlpha(255) : candleColor.withAlpha(200)
        ..strokeWidth = isSelected ? 2.0 : 1.0
        ..style = PaintingStyle.stroke;
      
      canvas.drawLine(Offset(x, highY), Offset(x, lowY), wickPaint);
      
      // Draw body (open-close rectangle)
      final bodyPaint = Paint()
        ..color = isSelected ? candleColor.withAlpha(255) : candleColor.withAlpha(200)
        ..style = isBullish ? PaintingStyle.stroke : PaintingStyle.fill
        ..strokeWidth = isSelected ? 2.0 : 1.0;
      
      final bodyTop = isBullish ? closeY : openY;
      final bodyBottom = isBullish ? openY : closeY;
      final bodyHeight = (bodyBottom - bodyTop).abs();
      
      final rect = Rect.fromLTWH(
        x - candleWidth / 2,
        bodyTop,
        candleWidth,
        bodyHeight > 1 ? bodyHeight : 1,
      );
      
      // Highlight selected candle
      if (isSelected) {
        final highlightPaint = Paint()
          ..color = candleColor.withAlpha(100)
          ..style = PaintingStyle.fill;
        
        final highlightRect = Rect.fromLTWH(
          x - candleWidth / 2 - 1,
          bodyTop - 1,
          candleWidth + 2,
          bodyHeight + 2,
        );
        canvas.drawRect(highlightRect, highlightPaint);
      }
      
      canvas.drawRect(rect, bodyPaint);
      
      if (isBullish && !isSelected) {
        final fillPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;
        canvas.drawRect(rect, fillPaint);
        canvas.drawRect(rect, bodyPaint);
      }
    }
    
    // Draw crosshair
    if (showCrosshair && touchPoint != null && selectedIndex != null) {
      _drawCrosshair(canvas, size);
    }
  }

  void _drawCrosshair(Canvas canvas, Size size) {
    if (touchPoint == null || selectedIndex == null) return;
    
    final crosshairPaint = Paint()
      ..color = crosshairColor.withAlpha(150)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    
    final dashPaint = Paint()
      ..color = crosshairColor.withAlpha(100)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    
    final candleSpacing = size.width / data.length;
    final x = selectedIndex! * candleSpacing + candleSpacing / 2;
    
    // Vertical line
    _drawDashedLine(canvas, Offset(x, 0), Offset(x, size.height), dashPaint);
    
    // Horizontal line
    _drawDashedLine(canvas, Offset(0, touchPoint!.dy), Offset(size.width, touchPoint!.dy), dashPaint);
    
    // Intersection point
    canvas.drawCircle(Offset(x, touchPoint!.dy), 3, crosshairPaint);
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashWidth = 5.0;
    const dashSpace = 3.0;
    
    final distance = (end - start).distance;
    final dashCount = (distance / (dashWidth + dashSpace)).floor().toDouble();
    
    if (dashCount == 0) return;
    
    final dashVector = (end - start) / dashCount;
    
    for (double i = 0; i < dashCount; i++) {
      final dashStart = start + dashVector * i;
      final dashEnd = dashStart + dashVector * (dashWidth / (dashWidth + dashSpace));
      canvas.drawLine(dashStart, dashEnd, paint);
    }
  }

  int? getCandleIndexFromPosition(Offset position, Size size) {
    if (data.isEmpty) return null;
    
    final candleSpacing = size.width / data.length;
    final index = (position.dx / candleSpacing).floor();
    
    return (index >= 0 && index < data.length) ? index : null;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! InteractiveChartPainter ||
        oldDelegate.data != data ||
        oldDelegate.touchPoint != touchPoint ||
        oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.maxPrice != maxPrice ||
        oldDelegate.minPrice != minPrice;
  }
}