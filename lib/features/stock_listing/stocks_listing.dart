import  'package:flutter/material.dart';
import 'package:flutter_application/features/stock_detail/stock_details.dart';
import 'package:flutter_application/features/stock_listing/bloc/stocks_listing_bloc.dart';
import 'package:flutter_application/features/stock_listing/bloc/stocks_listing_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/stocks_model.dart';

class ListingScreen extends StatelessWidget {
  const ListingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Market'),
        titleTextStyle: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: BlocBuilder<StocksListingBloc, StocksListingState>(
        builder: (context, state) {
          if (state is StocksLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading stocks...'),
                ],
              ),
            );
          } else if (state is StocksLoaded) {
            return ListView.builder(
              itemCount: state.stocks.length,
              itemBuilder: (context, index) {
                final stock = state.stocks[index];
                return GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StockDetails(stock: stock),
                      ),
                    );
                  },
                  child: StockTile(stock: stock),
                );
              },
            );
          } else if (state is StocksListingError) {
            return Center(child: Text(state.errorMessage));
          }
          return const Center(child: Text("No data available"));
        },
      ),
    );
  }
}

class StockTile extends StatelessWidget {
  final Stock stock;

  const StockTile({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    final isPositive = stock.change >= 0;
    final changeColor = isPositive 
        ? Colors.green.shade600 
        : Colors.red.shade600;
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stock.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  stock.symbol,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(700),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${stock.price.toStringAsFixed(2)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
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
            ],
          ),
        ],
      ),
    );
  }
}