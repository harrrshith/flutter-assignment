import 'package:equatable/equatable.dart';
import '../../../models/stocks_model.dart';

abstract class StocksListingState extends Equatable {
  const StocksListingState();

  @override
  List<Object?> get props => [];
}

class StocksListingInitial extends StocksListingState {}
class StocksLoading extends StocksListingState {}
class StocksLoaded extends StocksListingState {
  final List<Stock> stocks;
  const StocksLoaded({required this.stocks});
  
  @override
  List<Object?> get props => [stocks];
}
class StocksListingError extends StocksListingState {
  final String errorMessage;
  const StocksListingError({required this.errorMessage});
  
  @override
  List<Object?> get props => [errorMessage];
}