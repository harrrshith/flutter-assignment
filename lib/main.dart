import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application/ui/theme.dart';
import './features/stock_listing/stocks_listing.dart';
import './features/stock_listing/bloc/stocks_listing_bloc.dart';
import './features/stock_listing/bloc/stocks_listing_event.dart';

void main() {
  runApp(
    BlocProvider(
      create: (_) => StocksListingBloc()..add(LoadStock()),
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: ListingScreen(),
    );
  }
}
