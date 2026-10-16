import 'package:flutter/material.dart';
import 'package:mhwilds_app/utils/colors.dart';
import 'package:mhwilds_app/utils/game_colors.dart';

FocusNode myFocusNode = FocusNode();

class AppTheme {
  /// Esquemas generados desde el dorado para que `secondary`, `tertiary` y los
  /// contenedores de Material 3 no caigan en los colores por defecto de
  /// Flutter. Las superficies y `onSurfaceVariant` (texto secundario, >= 4,5:1)
  /// se fijan a mano para conservar el aspecto neutro de la app.
  static final ColorScheme lightScheme = ColorScheme.fromSeed(
    seedColor: AppColors.goldSoft,
    brightness: Brightness.light,
  ).copyWith(
    primary: AppColors.goldSoft,
    onPrimary: Colors.black87,
    secondary: AppColors.oliveBrown,
    onSecondary: Colors.white,
    tertiary: AppColors.mutedOlive,
    onTertiary: Colors.black87,
    surface: Colors.white,
    onSurface: Colors.black87,
    onSurfaceVariant: const Color(0xFF5F5F5F),
    surfaceContainerHighest: const Color(0xFFF5F5F5),
    outline: const Color(0xFFE0E0E0),
    outlineVariant: const Color(0xFFEEEEEE),
  );

  static final ColorScheme darkScheme = ColorScheme.fromSeed(
    seedColor: AppColors.goldSoft,
    brightness: Brightness.dark,
  ).copyWith(
    primary: AppColors.goldSoft,
    onPrimary: Colors.black87,
    secondary: AppColors.mutedOlive,
    onSecondary: Colors.black87,
    tertiary: AppColors.goldSoft,
    onTertiary: Colors.black87,
    surface: const Color(0xFF121212),
    onSurface: const Color(0xFFE0E0E0),
    onSurfaceVariant: const Color(0xFFB8B8B8),
    surfaceContainerHighest: const Color(0xFF2C2C2C),
    outline: const Color(0xFF404040),
    outlineVariant: const Color(0xFF383838),
  );

  static ThemeData get lightTheme {
    final colorScheme = lightScheme;
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      extensions: [GameColors.light],
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
        bodyLarge: TextStyle(color: Colors.black87, fontSize: 16, height: 1.4),
        bodyMedium: TextStyle(color: Colors.black87),
        titleLarge: TextStyle(
          color: Colors.black87,
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
        contentTextStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 16,
          height: 1.4,
        ),
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
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.goldInk),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: AppColors.goldInk),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.goldInk),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = darkScheme;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      extensions: [GameColors.dark],
      // En oscuro la barra no es el elemento más brillante: superficie con
      // título e iconos dorados.
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surfaceContainer,
        foregroundColor: colorScheme.primary,
        surfaceTintColor: Colors.transparent,
        elevation: 10,
        titleTextStyle: TextStyle(
          color: colorScheme.primary,
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
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 16,
          height: 1.4,
        ),
        bodyMedium: TextStyle(color: colorScheme.onSurface),
        titleLarge: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
        contentTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 16,
          height: 1.4,
        ),
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
        enabledBorder: const OutlineInputBorder(
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
