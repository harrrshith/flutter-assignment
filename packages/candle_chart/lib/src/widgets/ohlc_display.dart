import 'package:flutter/material.dart';
import '../models/candle_chart_data.dart';

class OHLCData {
  final CandleChartData candle;
  final int index;

  const OHLCData({
    required this.candle,
    required this.index,
  });

  double get open => candle.open;
  double get high => candle.high;
  double get low => candle.low;
  double get close => candle.close;
  double get volume => candle.volume;
  DateTime get timestamp => candle.timestamp;
  
  bool get isBullish => candle.isBullish;
  double get change => close - open;
  double get changePercent => (change / open) * 100;
}

class OHLCDisplay extends StatelessWidget {
  final OHLCData? ohlcData;
  final Color bullishColor;
  final Color bearishColor;
  final TextStyle? textStyle;
  final EdgeInsets padding;
  final bool showVolume;
  final bool showPercentage;
  final bool compact;

  const OHLCDisplay({
    super.key,
    this.ohlcData,
    this.bullishColor = Colors.green,
    this.bearishColor = Colors.red,
    this.textStyle,
    this.padding = const EdgeInsets.all(12.0),
    this.showVolume = true,
    this.showPercentage = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (ohlcData == null) {
      return Container(
        padding: padding,
        child: Text(
          'No data selected',
          style: textStyle ?? Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
      );
    }

    final data = ohlcData!;
    final changeColor = data.isBullish ? bullishColor : bearishColor;

    return Container(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildCompactValue('Open', data.open),
              const SizedBox(width: 12),
              _buildCompactValue('High', data.high),
            ],
          ),
          const SizedBox(width: 32),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildCompactValue('Low', data.low),
              const SizedBox(width: 12),
              _buildCompactValue('Close', data.close, color: changeColor),
            ]
          ),
        ],
      ),
    );
  }

  Widget _buildCompactValue(String label, double value, {Color? color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 6), // 👈 spacing between label and value
        Text(
          '₹${value.toStringAsFixed(2)}',
          style: (textStyle ?? const TextStyle()).copyWith(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}