import 'package:equatable/equatable.dart';
import '../../../models/stocks_model.dart';

abstract class StockDetailState extends Equatable{
  const StockDetailState();
  @override
  List<Object?> get props => [];
}

class StockDetailInitial extends StockDetailState {}
class StockDetailLoading extends StockDetailState {}

class StockDetailLoaded extends StockDetailState {
  final Stock stock;
  const StockDetailLoaded({required this.stock});
  @override
  List<Object?> get props => [stock];
}

class StockDetailError extends StockDetailState {
  final String errorMessage;
  const StockDetailError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}