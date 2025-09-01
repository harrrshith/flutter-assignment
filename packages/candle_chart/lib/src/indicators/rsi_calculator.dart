import '../models/candle_chart_data.dart';

class RSIData {
  final DateTime timestamp;
  final double rsi;
  final bool isOverbought;
  final bool isOversold;

  const RSIData({
    required this.timestamp,
    required this.rsi,
    required this.isOverbought,
    required this.isOversold,
  });
}

class RSICalculator {
  static const int defaultPeriod = 14;
  static const double overboughtLevel = 70.0;
  static const double oversoldLevel = 30.0;

  static List<RSIData> calculate(
    List<CandleChartData> data, {
    int period = defaultPeriod,
    double overbought = overboughtLevel,
    double oversold = oversoldLevel,
  }) {
    if (data.length < period + 1) return [];

    final List<RSIData> rsiData = [];
    final List<double> gains = [];
    final List<double> losses = [];

    for (int i = 1; i < data.length; i++) {
      final change = data[i].close - data[i - 1].close;
      gains.add(change > 0 ? change : 0);
      losses.add(change < 0 ? change.abs() : 0);

      if (i >= period) {
        final double avgGain = _calculateWilderSmoothing(gains, period, i - 1);
        final double avgLoss = _calculateWilderSmoothing(losses, period, i - 1);

        final double rs = avgLoss == 0 ? 100 : avgGain / avgLoss;
        final double rsi = 100 - (100 / (1 + rs));

        rsiData.add(RSIData(
          timestamp: data[i].timestamp,
          rsi: rsi,
          isOverbought: rsi > overbought,
          isOversold: rsi < oversold,
        ));
      }
    }

    return rsiData;
  }

  static double _calculateWilderSmoothing(List<double> values, int period, int index) {
    if (index < period - 1) return 0;

    if (index == period - 1) {
      return values.sublist(0, period).reduce((a, b) => a + b) / period;
    }

    final double previousAvg = _calculateWilderSmoothing(values, period, index - 1);
    return (previousAvg * (period - 1) + values[index]) / period;
  }

  static double getMinRSI() => 0.0;
  static double getMaxRSI() => 100.0;
}