import 'package:flutter/material.dart';
import '../models/candle_chart_data.dart';

class AxisPainter extends CustomPainter {
  final List<CandleChartData> data;
  final double maxPrice;
  final double minPrice;
  final Color textColor;
  final double fontSize;
  final EdgeInsets chartPadding;

  AxisPainter({
    required this.data,
    required this.maxPrice,
    required this.minPrice,
    this.textColor = Colors.black87,
    this.fontSize = 12.0,
    this.chartPadding = const EdgeInsets.only(left: 60, bottom: 40),
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    final chartWidth = size.width - chartPadding.left;
    final chartHeight = size.height - chartPadding.bottom;
    final priceRange = maxPrice - minPrice;
    
    if (priceRange == 0) return;

    _drawYAxisLabels(canvas, textPainter, chartHeight);
    _drawXAxisLabels(canvas, textPainter, chartWidth, chartHeight);
  }

  void _drawYAxisLabels(Canvas canvas, TextPainter textPainter, double chartHeight) {
    const labelCount = 6;
    final priceStep = (maxPrice - minPrice) / (labelCount - 1);

    for (int i = 0; i < labelCount; i++) {
      final price = maxPrice - (i * priceStep);
      final y = (chartHeight / (labelCount - 1)) * i;
      
      textPainter.text = TextSpan(
        text: _formatPrice(price),
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ),
      );
      
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(chartPadding.left - textPainter.width - 8, y - textPainter.height / 2),
      );
    }
  }

  void _drawXAxisLabels(Canvas canvas, TextPainter textPainter, double chartWidth, double chartHeight) {
    final labelCount = _calculateXAxisLabelCount(chartWidth);
    final step = (data.length / labelCount).ceil();
    
    for (int i = 0; i < labelCount && i * step < data.length; i++) {
      final dataIndex = i * step;
      final candle = data[dataIndex];
      final x = chartPadding.left + (dataIndex / (data.length - 1)) * chartWidth;
      
      textPainter.text = TextSpan(
        text: _formatTime(candle.timestamp),
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ),
      );
      
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, chartHeight + 8),
      );
    }
  }

  int _calculateXAxisLabelCount(double chartWidth) {
    final estimatedLabelWidth = fontSize * 8;
    return (chartWidth / estimatedLabelWidth).floor().clamp(3, 8);
  }

  String _formatPrice(double price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}M';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(1)}K';
    } else if (price >= 1) {
      return price.toStringAsFixed(2);
    } else {
      return price.toStringAsFixed(4);
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 30) {
      return '${_getMonthAbbr(timestamp.month)} ${timestamp.year.toString().substring(2)}';
    } else if (difference.inDays > 0) {
      return '${_getMonthAbbr(timestamp.month)} ${timestamp.day.toString().padLeft(2, '0')}';
    } else {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }

  String _getMonthAbbr(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  @override
  bool shouldRepaint(AxisPainter oldDelegate) =>
      data != oldDelegate.data ||
      maxPrice != oldDelegate.maxPrice ||
      minPrice != oldDelegate.minPrice;
}