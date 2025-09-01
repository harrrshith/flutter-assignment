// OHLC Utility functions for enhanced functionality
import 'package:flutter/material.dart';
import '../models/candle_chart_data.dart';
import '../widgets/ohlc_display.dart';

class OHLCUtils {
  // Calculate various OHLC-based indicators and statistics
  
  static double calculateRange(CandleChartData candle) {
    return candle.high - candle.low;
  }
  
  static double calculateBody(CandleChartData candle) {
    return (candle.close - candle.open).abs();
  }
  
  static double calculateUpperShadow(CandleChartData candle) {
    return candle.high - (candle.isBullish ? candle.close : candle.open);
  }
  
  static double calculateLowerShadow(CandleChartData candle) {
    return (candle.isBullish ? candle.open : candle.close) - candle.low;
  }
  
  static double calculateBodyPercentage(CandleChartData candle) {
    final range = calculateRange(candle);
    return range == 0 ? 0 : (calculateBody(candle) / range) * 100;
  }
  
  // Pattern recognition helpers
  static bool isDoji(CandleChartData candle, {double threshold = 0.1}) {
    final bodyPercent = calculateBodyPercentage(candle);
    return bodyPercent <= threshold;
  }
  
  static bool isHammer(CandleChartData candle, {double bodyThreshold = 30.0, double shadowRatio = 2.0}) {
    final body = calculateBody(candle);
    final lowerShadow = calculateLowerShadow(candle);
    final upperShadow = calculateUpperShadow(candle);
    final bodyPercent = calculateBodyPercentage(candle);
    
    return bodyPercent <= bodyThreshold && 
           lowerShadow >= body * shadowRatio && 
           upperShadow <= body;
  }
  
  static bool isShootingStar(CandleChartData candle, {double bodyThreshold = 30.0, double shadowRatio = 2.0}) {
    final body = calculateBody(candle);
    final lowerShadow = calculateLowerShadow(candle);
    final upperShadow = calculateUpperShadow(candle);
    final bodyPercent = calculateBodyPercentage(candle);
    
    return bodyPercent <= bodyThreshold && 
           upperShadow >= body * shadowRatio && 
           lowerShadow <= body;
  }
  
  // Statistical analysis
  static Map<String, double> getStatistics(List<CandleChartData> data) {
    if (data.isEmpty) return {};
    
    final volumes = data.map((d) => d.volume).toList();
    final ranges = data.map((d) => calculateRange(d)).toList();
    final bodies = data.map((d) => calculateBody(d)).toList();
    
    return {
      'avgVolume': volumes.reduce((a, b) => a + b) / volumes.length,
      'maxVolume': volumes.reduce((a, b) => a > b ? a : b),
      'minVolume': volumes.reduce((a, b) => a < b ? a : b),
      'avgRange': ranges.reduce((a, b) => a + b) / ranges.length,
      'maxRange': ranges.reduce((a, b) => a > b ? a : b),
      'minRange': ranges.reduce((a, b) => a < b ? a : b),
      'avgBody': bodies.reduce((a, b) => a + b) / bodies.length,
      'bullishCount': data.where((d) => d.isBullish).length.toDouble(),
      'bearishCount': data.where((d) => !d.isBullish).length.toDouble(),
    };
  }
  
  // Formatting helpers for OHLC display
  static String formatPrice(double price, {int decimals = 2}) {
    return '₹${price.toStringAsFixed(decimals)}';
  }
  
  static String formatVolume(double volume) {
    if (volume >= 1000000000) {
      return '${(volume / 1000000000).toStringAsFixed(1)}B';
    } else if (volume >= 1000000) {
      return '${(volume / 1000000).toStringAsFixed(1)}M';
    } else if (volume >= 1000) {
      return '${(volume / 1000).toStringAsFixed(1)}K';
    }
    return volume.toStringAsFixed(0);
  }
  
  static String formatPercentage(double percentage, {bool showSign = true}) {
    final sign = showSign && percentage >= 0 ? '+' : '';
    return '$sign${percentage.toStringAsFixed(2)}%';
  }
  
  static String formatDateTime(DateTime dateTime, {bool includeTime = false}) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    
    final dateStr = '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';
    
    if (includeTime) {
      final timeStr = '${dateTime.hour.toString().padLeft(2, '0')}:'
                     '${dateTime.minute.toString().padLeft(2, '0')}';
      return '$dateStr $timeStr';
    }
    
    return dateStr;
  }
  
  // Color helpers for different candle characteristics
  static Color getCandleColor(CandleChartData candle, {
    Color bullishColor = Colors.green,
    Color bearishColor = Colors.red,
    Color dojiColor = Colors.grey,
  }) {
    if (isDoji(candle)) return dojiColor;
    return candle.isBullish ? bullishColor : bearishColor;
  }
  
  static Color getVolumeColor(CandleChartData candle, double avgVolume, {
    Color highVolumeColor = Colors.orange,
    Color normalVolumeColor = Colors.blue,
  }) {
    return candle.volume > avgVolume * 1.5 ? highVolumeColor : normalVolumeColor;
  }
  
  // Chart interaction helpers
  static int? findNearestCandleIndex(
    List<CandleChartData> data,
    Offset touchPoint,
    Size chartSize,
  ) {
    if (data.isEmpty) return null;
    
    final candleSpacing = chartSize.width / data.length;
    final index = (touchPoint.dx / candleSpacing).floor();
    
    return (index >= 0 && index < data.length) ? index : null;
  }
  
  static Offset getCandlePosition(
    int index,
    List<CandleChartData> data,
    Size chartSize,
    double minPrice,
    double maxPrice,
  ) {
    if (index < 0 || index >= data.length) return Offset.zero;
    
    final candle = data[index];
    final candleSpacing = chartSize.width / data.length;
    final priceRange = maxPrice - minPrice;
    
    final x = index * candleSpacing + candleSpacing / 2;
    final y = chartSize.height - ((candle.close - minPrice) / priceRange) * chartSize.height;
    
    return Offset(x, y);
  }
  
  // Validation helpers
  static bool isValidOHLC(CandleChartData candle) {
    return candle.high >= candle.low &&
           candle.high >= candle.open &&
           candle.high >= candle.close &&
           candle.low <= candle.open &&
           candle.low <= candle.close &&
           candle.volume >= 0;
  }
  
  static List<String> validateOHLCData(List<CandleChartData> data) {
    final errors = <String>[];
    
    if (data.isEmpty) {
      errors.add('No data provided');
      return errors;
    }
    
    for (int i = 0; i < data.length; i++) {
      final candle = data[i];
      
      if (!isValidOHLC(candle)) {
        errors.add('Invalid OHLC data at index $i: ${candle.toString()}');
      }
      
      if (i > 0) {
        final prevCandle = data[i - 1];
        if (candle.timestamp.isBefore(prevCandle.timestamp)) {
          errors.add('Timestamps not in chronological order at index $i');
        }
      }
    }
    
    return errors;
  }
}

// Extension methods for easier OHLC data manipulation
extension CandleChartDataExtensions on CandleChartData {
  double get range => high - low;
  double get body => (close - open).abs();
  double get upperShadow => high - (isBullish ? close : open);
  double get lowerShadow => (isBullish ? open : close) - low;
  double get bodyPercentage => range == 0 ? 0 : (body / range) * 100;
  double get change => close - open;
  double get changePercentage => (change / open) * 100;
  
  bool get isDoji => bodyPercentage <= 0.1;
  bool get isLongCandle => bodyPercentage > 70;
  bool get isHighVolume => volume > 1000000; // This should be dynamic based on average
  
  String get priceString => '₹${close.toStringAsFixed(2)}';
  String get changeString => '${changePercentage >= 0 ? '+' : ''}${changePercentage.toStringAsFixed(2)}%';
  String get volumeString => OHLCUtils.formatVolume(volume);
  String get dateString => OHLCUtils.formatDateTime(timestamp);
  
  OHLCData toOHLCData(int index) => OHLCData(candle: this, index: index);
}