import 'package:flutter/material.dart';

class AppColors {
  static const blue = Color(0xFF1565C0);   // main brand color
  static const blueLight = Color(0xFF5E92F3);
  static const blueDark = Color(0xFF003c8f);

  static const orange = Color(0xFFFF9800); // secondary/accent
  static const greyLight = Color(0xFFF5F5F5);
  static const greyDark = Color(0xFF121212);

  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFFC107);
  static const error = Color(0xFFF44336);
}


class AppTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.blue,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.blue,
      onPrimary: Colors.white, // text/icons on blue
      secondary: AppColors.orange,
      onSecondary: Colors.white,
      surface: AppColors.greyLight,
      onSurface: Colors.black,
      error: AppColors.error,
      onError: Colors.white,
    ),
    fontFamily: 'Montserrat',
    useMaterial3: true,
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.blue,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppColors.blueLight,
      onPrimary: Colors.white,
      secondary: AppColors.orange,
      onSecondary: Colors.black,
      surface: AppColors.greyDark,
      onSurface: Colors.white,
      error: AppColors.error,
      onError: Colors.black,
    ),
    fontFamily: 'Montserrat',
    useMaterial3: true,
  );
}