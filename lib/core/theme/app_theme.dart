import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    scaffoldBackgroundColor: AppColors.background,

    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.white,
      error: AppColors.error,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,
    ),

    // textTheme: const TextTheme(
    //   headlineLarge: TextStyle(
    //     fontSize: 32,
    //     fontWeight: FontWeight.bold,
    //     color: AppColors.black,
    //   ),

    //   headlineMedium: TextStyle(
    //     fontSize: 24,
    //     fontWeight: FontWeight.bold,
    //     color: AppColors.black,
    //   ),

    //   titleLarge: TextStyle(
    //     fontSize: 18,
    //     fontWeight: FontWeight.w600,
    //     color: AppColors.black,
    //   ),

    //   bodyLarge: TextStyle(fontSize: 16, color: AppColors.black),

    //   bodyMedium: TextStyle(fontSize: 14, color: AppColors.grey),
    // ),

    // inputDecorationTheme: InputDecorationTheme(
    //   filled: true,
    //   fillColor: AppColors.white,

    //   border: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(12),
    //     borderSide: BorderSide.none,
    //   ),

    //   enabledBorder: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(12),
    //     borderSide: BorderSide(color: Colors.grey.shade300),
    //   ),

    //   focusedBorder: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(12),
    //     borderSide: const BorderSide(color: AppColors.primary, width: 2),
    //   ),

    //   contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    // ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,

        minimumSize: const Size(double.infinity, 52),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.primary),
    ),
  );
}
