// RSI Configuration utility for easier chart customization
// This is optional - you can configure RSI directly in CandleChart widget

import 'package:flutter/material.dart';

class RSIPresets {
  static const conservative = RSIConfig(
    period: 14,
    overboughtLevel: 80.0,
    oversoldLevel: 20.0,
    lineColor: Colors.blue,
  );

  static const aggressive = RSIConfig(
    period: 9,
    overboughtLevel: 65.0,
    oversoldLevel: 35.0,
    lineColor: Colors.orange,
  );

  static const longTerm = RSIConfig(
    period: 21,
    overboughtLevel: 75.0,
    oversoldLevel: 25.0,
    lineColor: Colors.purple,
  );

  static const dayTrading = RSIConfig(
    period: 7,
    overboughtLevel: 70.0,
    oversoldLevel: 30.0,
    lineColor: Colors.red,
  );
}

class RSIConfig {
  final int period;
  final double overboughtLevel;
  final double oversoldLevel;
  final Color lineColor;
  final Color overboughtColor;
  final Color oversoldColor;
  final double height;
  final bool showLevels;
  final bool showFill;

  const RSIConfig({
    this.period = 14,
    this.overboughtLevel = 70.0,
    this.oversoldLevel = 30.0,
    this.lineColor = Colors.purple,
    this.overboughtColor = Colors.red,
    this.oversoldColor = Colors.green,
    this.height = 120.0,
    this.showLevels = true,
    this.showFill = false,
  });

  RSIConfig copyWith({
    int? period,
    double? overboughtLevel,
    double? oversoldLevel,
    Color? lineColor,
    Color? overboughtColor,
    Color? oversoldColor,
    double? height,
    bool? showLevels,
    bool? showFill,
  }) {
    return RSIConfig(
      period: period ?? this.period,
      overboughtLevel: overboughtLevel ?? this.overboughtLevel,
      oversoldLevel: oversoldLevel ?? this.oversoldLevel,
      lineColor: lineColor ?? this.lineColor,
      overboughtColor: overboughtColor ?? this.overboughtColor,
      oversoldColor: oversoldColor ?? this.oversoldColor,
      height: height ?? this.height,
      showLevels: showLevels ?? this.showLevels,
      showFill: showFill ?? this.showFill,
    );
  }

  bool get isValidPeriod => period >= 2 && period <= 50;
  bool get isValidOverboughtLevel => overboughtLevel > 50 && overboughtLevel < 100;
  bool get isValidOversoldLevel => oversoldLevel > 0 && oversoldLevel < 50;
  bool get hasValidLevels => overboughtLevel > oversoldLevel;
  
  bool get isValid => isValidPeriod && 
                     isValidOverboughtLevel && 
                     isValidOversoldLevel && 
                     hasValidLevels;

  @override
  String toString() => 'RSI($period) OB:$overboughtLevel OS:$oversoldLevel';
}