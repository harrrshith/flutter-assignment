import 'package:flutter/services.dart' show rootBundle;
import '../models/stocks_model.dart';

Future<List<Stock>> loadStocks() async {
  final String jsonString = await rootBundle.loadString('assets/data/nifty50_stocks.json');
  return Stock.fromJsonList(jsonString);
}
