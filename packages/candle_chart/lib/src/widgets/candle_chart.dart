import 'package:flutter/material.dart';
import '../models/candle_chart_data.dart';
import '../painters/chart_painter.dart';
import '../painters/grid_painter.dart';
import '../painters/axis_painter.dart';

class CandleChart extends StatelessWidget {
  final List<CandleChartData> data;
  final Color bullishColor;
  final Color bearishColor;
  final double candleWidth;
  final EdgeInsets padding;
  final bool showGrid;
  final bool showAxis;
  final Color gridColor;
  final Color axisTextColor;
  final double axisTextSize;

  const CandleChart({
    super.key,
    required this.data,
    this.bullishColor = Colors.green,
    this.bearishColor = Colors.red,
    this.candleWidth = 8.0,
    this.padding = const EdgeInsets.all(16.0),
    this.showGrid = true,
    this.showAxis = true,
    this.gridColor = Colors.grey,
    this.axisTextColor = Colors.black87,
    this.axisTextSize = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Container(
        padding: padding,
        child: const Center(
          child: Text('No data available'),
        ),
      );
    }

    final prices = data.expand((d) => [d.open, d.high, d.low, d.close]).toList();
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);
    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    
    final chartPadding = showAxis 
        ? const EdgeInsets.only(left: 30, bottom: 15)
        : EdgeInsets.zero;

    return Container(
      padding: padding,
      child: Stack(
        children: [
          if (showGrid)
            Positioned.fill(
              left: chartPadding.left,
              bottom: chartPadding.bottom,
              child: CustomPaint(
                painter: GridPainter(
                  maxPrice: maxPrice,
                  minPrice: minPrice,
                  color: gridColor.withAlpha(100),
                ),
              ),
            ),
          Positioned.fill(
            left: chartPadding.left,
            bottom: chartPadding.bottom,
            child: CustomPaint(
              painter: CandleChartPainter(
                data: data,
                maxPrice: maxPrice,
                minPrice: minPrice,
                bullishColor: bullishColor,
                bearishColor: bearishColor,
                candleWidth: candleWidth,
              ),
            ),
          ),
          if (showAxis)
            CustomPaint(
              size: Size.infinite,
              painter: AxisPainter(
                data: data,
                maxPrice: maxPrice,
                minPrice: minPrice,
                textColor: axisTextColor,
                fontSize: axisTextSize,
                chartPadding: chartPadding,
              ),
            ),
        ],
      ),
    );
  }
}
