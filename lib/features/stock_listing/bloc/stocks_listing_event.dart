import 'package:equatable/equatable.dart';

abstract class StocksListingEvent extends Equatable {
  const StocksListingEvent();

  @override
  List<Object> get props => [];
}

class LoadStock extends StocksListingEvent {}
