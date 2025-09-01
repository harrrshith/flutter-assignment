import 'package:flutter/material.dart';
import '../models/candle_chart_data.dart';
import '../painters/chart_painter.dart';
import '../painters/grid_painter.dart';
import '../painters/axis_painter.dart';
import '../painters/rsi_painter.dart';
import '../painters/rsi_axis_painter.dart';
import '../painters/interactive_chart_painter.dart';
import '../indicators/rsi_calculator.dart';
import 'ohlc_display.dart';

class CandleChart extends StatefulWidget {
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
  
  // RSI Configuration
  final bool showRSI;
  final double rsiHeight;
  final int rsiPeriod;
  final Color rsiLineColor;
  final Color rsiOverboughtColor;
  final Color rsiOversoldColor;
  final double rsiOverboughtLevel;
  final double rsiOversoldLevel;
  final bool showRSILevels;
  final bool showRSIFill;
  
  // OHLC Configuration
  final bool showOHLC;
  final bool ohlcCompact;
  final bool showOHLCVolume;
  final bool showOHLCPercentage;
  final EdgeInsets ohlcPadding;
  final TextStyle? ohlcTextStyle;
  
  // Interaction Configuration
  final bool enableInteraction;
  final bool showCrosshair;
  final Color crosshairColor;
  final Function(int index, CandleChartData candle)? onCandleSelected;

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
    this.showRSI = false,
    this.rsiHeight = 100.0,
    this.rsiPeriod = 14,
    this.rsiLineColor = Colors.purple,
    this.rsiOverboughtColor = Colors.red,
    this.rsiOversoldColor = Colors.green,
    this.rsiOverboughtLevel = 70.0,
    this.rsiOversoldLevel = 30.0,
    this.showRSILevels = true,
    this.showRSIFill = false,
    this.showOHLC = true,
    this.ohlcCompact = false,
    this.showOHLCVolume = true,
    this.showOHLCPercentage = true,
    this.ohlcPadding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    this.ohlcTextStyle,
    this.enableInteraction = true,
    this.showCrosshair = true,
    this.crosshairColor = Colors.grey,
    this.onCandleSelected,
  });

  @override
  State<CandleChart> createState() => _CandleChartState();
}

class _CandleChartState extends State<CandleChart> {
  int? _selectedIndex;
  Offset? _touchPosition;
  final GlobalKey _chartKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.data.isNotEmpty && widget.showOHLC) {
      _selectedIndex = widget.data.length - 1;
      _notifySelection();
    }
  }

  @override
  void didUpdateWidget(CandleChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data) {
      if (widget.data.isNotEmpty && widget.showOHLC) {
        _selectedIndex = widget.data.length - 1;
        _notifySelection();
      } else {
        _selectedIndex = null;
        _touchPosition = null;
      }
    }
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (!widget.enableInteraction || widget.data.isEmpty) return;

    final RenderBox? renderBox = _chartKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final localPosition = renderBox.globalToLocal(details.globalPosition);
    final chartSize = renderBox.size;
    final chartPadding = widget.showAxis 
        ? const EdgeInsets.only(left: 30, bottom: 15)
        : EdgeInsets.zero;
    
    final adjustedPosition = Offset(
      localPosition.dx - chartPadding.left,
      localPosition.dy,
    );

    final adjustedSize = Size(
      chartSize.width - chartPadding.left,
      chartSize.height - chartPadding.bottom,
    );

    if (adjustedPosition.dx >= 0 && 
        adjustedPosition.dx <= adjustedSize.width &&
        adjustedPosition.dy >= 0 && 
        adjustedPosition.dy <= adjustedSize.height) {
      
      final candleSpacing = adjustedSize.width / widget.data.length;
      final index = (adjustedPosition.dx / candleSpacing).floor();
      
      if (index >= 0 && index < widget.data.length) {
        setState(() {
          _selectedIndex = index;
          _touchPosition = adjustedPosition;
        });
        _notifySelection();
      }
    }
  }

  void _handleTap(TapUpDetails details) {
    if (!widget.enableInteraction || widget.data.isEmpty) return;

    final RenderBox? renderBox = _chartKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final localPosition = renderBox.globalToLocal(details.globalPosition);
    final chartSize = renderBox.size;
    
    final chartPadding = widget.showAxis 
        ? const EdgeInsets.only(left: 30, bottom: 15)
        : EdgeInsets.zero;
    
    final adjustedPosition = Offset(
      localPosition.dx - chartPadding.left,
      localPosition.dy,
    );

    final adjustedSize = Size(
      chartSize.width - chartPadding.left,
      chartSize.height - chartPadding.bottom,
    );

    if (adjustedPosition.dx >= 0 && 
        adjustedPosition.dx <= adjustedSize.width &&
        adjustedPosition.dy >= 0 && 
        adjustedPosition.dy <= adjustedSize.height) {
      
      final candleSpacing = adjustedSize.width / widget.data.length;
      final index = (adjustedPosition.dx / candleSpacing).floor();
      
      if (index >= 0 && index < widget.data.length) {
        setState(() {
          _selectedIndex = index;
          _touchPosition = adjustedPosition;
        });
        _notifySelection();
      }
    }
  }

  void _notifySelection() {
    if (_selectedIndex != null && 
        _selectedIndex! >= 0 && 
        _selectedIndex! < widget.data.length &&
        widget.onCandleSelected != null) {
      widget.onCandleSelected!(_selectedIndex!, widget.data[_selectedIndex!]);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return Container(
        padding: widget.padding,
        child: const Center(
          child: Text('No data available'),
        ),
      );
    }

    final prices = widget.data.expand((d) => [d.open, d.high, d.low, d.close]).toList();
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);
    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    
    final chartPadding = widget.showAxis 
        ? const EdgeInsets.only(left: 30, bottom: 15)
        : EdgeInsets.zero;

    final rsiData = widget.showRSI ? RSICalculator.calculate(
      widget.data,
      period: widget.rsiPeriod,
      overbought: widget.rsiOverboughtLevel,
      oversold: widget.rsiOversoldLevel,
    ) : <RSIData>[];

    // Build OHLC data for display
    OHLCData? ohlcData;
    if (widget.showOHLC && _selectedIndex != null && _selectedIndex! < widget.data.length) {
      ohlcData = OHLCData(
        candle: widget.data[_selectedIndex!],
        index: _selectedIndex!,
      );
    }

    final mainChart = Container(
      padding: widget.padding,
      child: Column(
        children: [
          if (widget.showOHLC)
            OHLCDisplay(
              ohlcData: ohlcData,
              bullishColor: widget.bullishColor,
              bearishColor: widget.bearishColor,
              textStyle: widget.ohlcTextStyle,
              padding: widget.ohlcPadding,
              showVolume: widget.showOHLCVolume,
              showPercentage: widget.showOHLCPercentage,
              compact: widget.ohlcCompact,
            ),
          Expanded(
            flex: widget.showRSI ? 3 : 1,
            child: _buildMainChart(chartPadding, maxPrice, minPrice),
          ),
          if (widget.showRSI) ...[
            const SizedBox(height: 8),
            SizedBox(
              height: widget.rsiHeight,
              child: _buildRSIChart(rsiData, chartPadding),
            ),
          ],
        ],
      ),
    );
    
    if (widget.enableInteraction) {
      return GestureDetector(
        onPanUpdate: _handlePanUpdate,
        onTapUp: _handleTap,
        child: mainChart,
      );
    }

    return mainChart;
  }

  Widget _buildMainChart(
    EdgeInsets chartPadding, 
    double maxPrice, 
    double minPrice,
  ) {
    return Container(
      key: _chartKey,
      child: Stack(
        children: [
          if (widget.showGrid)
            Positioned.fill(
              left: chartPadding.left,
              bottom: chartPadding.bottom,
              child: CustomPaint(
                painter: GridPainter(
                  maxPrice: maxPrice,
                  minPrice: minPrice,
                  color: widget.gridColor.withAlpha(100),
                ),
              ),
            ),
          Positioned.fill(
            left: chartPadding.left,
            bottom: chartPadding.bottom,
            child: CustomPaint(
              painter: widget.enableInteraction
                  ? InteractiveChartPainter(
                      data: widget.data,
                      maxPrice: maxPrice,
                      minPrice: minPrice,
                      bullishColor: widget.bullishColor,
                      bearishColor: widget.bearishColor,
                      candleWidth: widget.candleWidth,
                      touchPoint: _touchPosition,
                      selectedIndex: _selectedIndex,
                      crosshairColor: widget.crosshairColor,
                      showCrosshair: widget.showCrosshair,
                    )
                  : CandleChartPainter(
                      data: widget.data,
                      maxPrice: maxPrice,
                      minPrice: minPrice,
                      bullishColor: widget.bullishColor,
                      bearishColor: widget.bearishColor,
                      candleWidth: widget.candleWidth,
                    ),
            ),
          ),
          if (widget.showAxis)
            CustomPaint(
              size: Size.infinite,
              painter: AxisPainter(
                data: widget.data,
                maxPrice: maxPrice,
                minPrice: minPrice,
                textColor: widget.axisTextColor,
                fontSize: widget.axisTextSize,
                chartPadding: chartPadding,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRSIChart(List<RSIData> rsiData, EdgeInsets chartPadding) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: widget.gridColor.withAlpha(100)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            left: chartPadding.left,
            child: CustomPaint(
              painter: RSIPainter(
                rsiData: rsiData,
                lineColor: widget.rsiLineColor,
                overboughtColor: widget.rsiOverboughtColor,
                oversoldColor: widget.rsiOversoldColor,
                overboughtLevel: widget.rsiOverboughtLevel,
                oversoldLevel: widget.rsiOversoldLevel,
                showLevels: widget.showRSILevels,
                showFill: widget.showRSIFill,
              ),
            ),
          ),
          if (widget.showAxis)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 35,
              child: CustomPaint(
                painter: RSIAxisPainter(
                  textColor: widget.axisTextColor,
                  fontSize: widget.axisTextSize,
                  overboughtLevel: widget.rsiOverboughtLevel,
                  oversoldLevel: widget.rsiOversoldLevel,
                ),
              ),
            ),
          Positioned(
            left: 5,
            top: 5,
            child: Text(
              'RSI(${widget.rsiPeriod})',
              style: TextStyle(
                color: widget.rsiLineColor,
                fontSize: widget.axisTextSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}