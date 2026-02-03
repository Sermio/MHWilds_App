import 'package:flutter/material.dart';
import 'package:mhwilds_app/utils/colors.dart';

FocusNode myFocusNode = FocusNode();

class AppTheme {
  static ThemeData get lightTheme {
    const colorScheme = ColorScheme.light(
      primary: AppColors.goldSoft,
      onPrimary: Colors.black87,
      surface: Colors.white,
      onSurface: Colors.black87,
      surfaceContainerHighest: Color(0xFFF5F5F5),
      outline: Color(0xFFE0E0E0),
      outlineVariant: Color(0xFFEEEEEE),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.goldSoft,
        foregroundColor: Colors.black87,
        elevation: 10,
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      drawerTheme: const DrawerThemeData(backgroundColor: Colors.white),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.goldSoft,
        foregroundColor: Colors.black87,
        elevation: 10,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.black87),
      ),
      cardTheme: CardThemeData(
        shadowColor: AppColors.goldSoft,
        color: colorScheme.surface,
        elevation: 3,
      ),
      scaffoldBackgroundColor: colorScheme.surface,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.goldSoft,
          foregroundColor: Colors.black87,
          elevation: 5,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: const BorderSide(color: AppColors.goldSoft, width: 2),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: colorScheme.onSurface),
        fillColor: colorScheme.surfaceContainerHighest,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.goldSoft),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: AppColors.goldSoft),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.goldSoft),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  static ThemeData get darkTheme {
    const colorScheme = ColorScheme.dark(
      primary: AppColors.goldSoft,
      onPrimary: Colors.black87,
      surface: Color(0xFF121212),
      onSurface: Color(0xFFE0E0E0),
      surfaceContainerHighest: Color(0xFF2C2C2C),
      outline: Color(0xFF404040),
      outlineVariant: Color(0xFF383838),
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.goldSoft,
        foregroundColor: Colors.black87,
        elevation: 10,
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFF121212)),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.goldSoft,
        foregroundColor: Colors.black87,
        elevation: 10,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Color(0xFFE0E0E0)),
      ),
      cardTheme: CardThemeData(
        shadowColor: Colors.black54,
        color: colorScheme.surfaceContainerHighest,
        elevation: 3,
      ),
      scaffoldBackgroundColor: colorScheme.surface,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.goldSoft,
          foregroundColor: Colors.black87,
          elevation: 5,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: const BorderSide(color: AppColors.goldSoft, width: 2),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: colorScheme.onSurface),
        fillColor: colorScheme.surfaceContainerHighest,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.goldSoft),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: AppColors.goldSoft),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.goldSoft),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
}
