import 'package:flutter_bloc/flutter_bloc.dart';
import 'stock_detail_state.dart';
import 'stock_detail_event.dart';
import '../../../models/stocks_model.dart';
import '../../../utils/stocks_data.dart';


class StockDetailBloc extends Bloc<StockDetailEvent, StockDetailState>{
  StockDetailBloc(): super(StockDetailInitial()) {
    on<LoadStockDetail>(_onLoadStockDetail);
  }
  Future<void> _onLoadStockDetail(LoadStockDetail event, Emitter<StockDetailState> emit) async {
    try {
      final List<Stock> stocks = await loadStocks();
      final stock = stocks.firstWhere(
        (s) => s.symbol == event.symbol,
        orElse: () => throw Exception('Stock not found: ${event.symbol}'),
      );
      emit(StockDetailLoaded(stock: stock));
    } catch (e) {
      emit(StockDetailError(errorMessage: e.toString()));
    }
  }
}