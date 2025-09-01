import 'package:candle_chart/candle_chart.dart';
import 'dart:convert';

class Stock {
  final String name;
  final String symbol;
  final double price;
  final double change;
  final List<CandleChartData> stockData;

  Stock({
    required this.name,
    required this.symbol,
    required this.price,
    required this.change,
    required this.stockData,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      price: (json['price'] as num).toDouble(),
      change: (json['change'] as num).toDouble(),
      stockData: (json['stockData'] as List<dynamic>)
          .map((item) => CandleChartData.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'symbol': symbol,
      'price': price,
      'change': change,
      'stockData': stockData.map((candle) => candle.toJson()).toList(),
    };
  }

  static List<Stock> fromJsonList(String jsonString) {
    final List<dynamic> data = json.decode(jsonString);
    return data.map((item) => Stock.fromJson(item)).toList();
  }

  static String toJsonList(List<Stock> stocks) {
    final data = stocks.map((stock) => stock.toJson()).toList();
    return json.encode(data);
  }
}