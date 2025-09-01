import 'package:flutter/material.dart';
import '../models/candle_chart_data.dart';

class CandleChartPainter extends CustomPainter {
  final List<CandleChartData> data;
  final double maxPrice;
  final double minPrice;
  final Color bullishColor;
  final Color bearishColor;
  final double candleWidth;

  CandleChartPainter({
    required this.data,
    required this.maxPrice,
    required this.minPrice,
    this.bullishColor = Colors.green,
    this.bearishColor = Colors.red,
    this.candleWidth = 10.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()..strokeWidth = 1.0;
    final candleSpacing = size.width / data.length;
    final priceRange = maxPrice - minPrice;
    
    if (priceRange == 0) return;

    for (int i = 0; i < data.length; i++) {
      final candle = data[i];
      final x = (i + 0.5) * candleSpacing;
      
      final openY = size.height - ((candle.open - minPrice) / priceRange) * size.height;
      final closeY = size.height - ((candle.close - minPrice) / priceRange) * size.height;
      final highY = size.height - ((candle.high - minPrice) / priceRange) * size.height;
      final lowY = size.height - ((candle.low - minPrice) / priceRange) * size.height;

      paint.color = candle.isBullish ? bullishColor : bearishColor;

      // Draw wicks
      canvas.drawLine(Offset(x, highY), Offset(x, lowY), paint);

      // Draw candle body
      final bodyTop = candle.isBullish ? closeY : openY;
      final bodyBottom = candle.isBullish ? openY : closeY;
      final bodyHeight = (bodyBottom - bodyTop).abs();
      
      if (bodyHeight < 1.0) {
        canvas.drawLine(
          Offset(x - candleWidth / 2, bodyTop),
          Offset(x + candleWidth / 2, bodyTop),
          paint..strokeWidth = 2.0,
        );
      } else {
        canvas.drawRect(
          Rect.fromLTWH(x - candleWidth / 2, bodyTop, candleWidth, bodyHeight),
          paint..style = PaintingStyle.fill,
        );
      }
      
      paint.strokeWidth = 1.0;
    }
  }

  @override
  bool shouldRepaint(CandleChartPainter oldDelegate) =>
      data != oldDelegate.data ||
      maxPrice != oldDelegate.maxPrice ||
      minPrice != oldDelegate.minPrice;
}