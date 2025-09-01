import 'package:flutter_bloc/flutter_bloc.dart';
import 'stocks_listing_event.dart';
import 'stocks_listing_state.dart';
import '../../../models/stocks_model.dart';
import '../../../utils/stocks_data.dart';

class StocksListingBloc extends Bloc<StocksListingEvent,StocksListingState> {
  StocksListingBloc() : super(StocksListingInitial()) {
    on<StocksListingEvent>(_onLoadStocks);
  }

  void _onLoadStocks(StocksListingEvent event, Emitter<StocksListingState> emit) async{
    emit(StocksLoading());
    try {
      final List<Stock> stocks = await loadStocks();
      emit(StocksLoaded(stocks: stocks));
    } catch (e) {
      emit(StocksListingError(errorMessage: e.toString()));
    }
  }
}
