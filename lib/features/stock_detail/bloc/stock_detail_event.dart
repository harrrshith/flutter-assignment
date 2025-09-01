import 'package:equatable/equatable.dart';

abstract class StockDetailEvent extends Equatable{
  const StockDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadStockDetail extends StockDetailEvent {
  final String symbol;
  const LoadStockDetail(this.symbol);

  @override
  List<Object?> get props => [symbol];
}