import 'dart:convert';

class CandleChartData {
  final DateTime timestamp;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;


  const CandleChartData({
    required this.timestamp,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume
  });

  bool get isBullish => close > open;
  double get body => (close - open).abs();
  double get upperShadow =>  high - (isBullish ? close : open);
  double get lowerShadow => (isBullish ? open : close) - low;

  factory CandleChartData.fromJson(Map<String, dynamic> json) {
    return CandleChartData(
      timestamp: DateTime.parse(json['timestamp'] as String),
      open: (json['open'] as num).toDouble(),
      high: (json['high'] as num).toDouble(),
      low: (json['low'] as num).toDouble(),
      close: (json['close'] as num).toDouble(),
      volume: (json['volume'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'open': open,
      'high': high,
      'low': low,
      'close': close,
      'volume': volume,
    };
  }

  static List<CandleChartData> fromJsonList(String jsonString) {
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => CandleChartData.fromJson(json)).toList();
  }

  static String toJsonList(List<CandleChartData> data) {
    final List<Map<String, dynamic>> jsonList = 
        data.map((candle) => candle.toJson()).toList();
    return json.encode(jsonList);
  }
}