import 'package:flutter/material.dart';
import 'package:flutter_application/features/stock_detail/bloc/stock_detail_bloc.dart';
import '../stock_detail/bloc/stock_detail_event.dart';
import '../stock_detail/bloc/stock_detail_state.dart';
import '../../../models/stocks_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:candle_chart/candle_chart.dart';

const textStyle = TextStyle(
  fontSize: 12.0,
  fontWeight: FontWeight.normal,
  color: Colors.black
);

class StockDetails extends StatelessWidget {
  final Stock stock;
  const StockDetails({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    final isPositive = stock.change >= 0;
    final changeColor = isPositive 
        ? Colors.green.shade600 
        : Colors.red.shade600;
    return BlocProvider(
      create: (_) => StockDetailBloc()..add(LoadStockDetail(stock.symbol)),
      child: Scaffold(
        appBar: AppBar(title: Text("${stock.name}\n${stock.symbol}"), centerTitle: false, titleTextStyle: textStyle),
        body: BlocBuilder<StockDetailBloc, StockDetailState>(
          builder: (context, state) {
            if (state is StockDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StockDetailLoaded) {
              final detail = state.stock;
              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      top: 16.0,
                      left: 22.0,
                      right: 32.0,
                      bottom: 8.0
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹${stock.price.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isPositive ? Icons.trending_up : Icons.trending_down,
                              color: changeColor,
                              size: 14,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${isPositive ? '+' : ''}${stock.change.toStringAsFixed(2)}%',
                              style: TextStyle(
                                color: changeColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ]
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                      child: CandleChart(
                        data: detail.stockData,
                        bullishColor: Colors.green.shade600,
                        bearishColor: Colors.red.shade600,
                        candleWidth: 6.0,
                        showGrid: true,
                        gridColor: Colors.grey.shade400,
                      ),
                      )
                  ),
                  SizedBox(height: 200.0,)
                ]
              );
            } else if (state is StockDetailError) {
              return Center(child: Text(state.errorMessage));
            }
            return const SizedBox();
          },
        )
      )
    );
  }
}