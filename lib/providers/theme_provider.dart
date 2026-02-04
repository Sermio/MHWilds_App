import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { light, dark, system }

class ThemeProvider extends ChangeNotifier {
  static const String _keyThemeMode = 'app_theme_mode';

  AppThemeMode _mode = AppThemeMode.light;

  AppThemeMode get mode => _mode;

  ThemeMode get themeMode {
    switch (_mode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  ThemeProvider() {
    _loadSavedMode();
  }

  Future<void> _loadSavedMode() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_keyThemeMode);
    if (index != null && index >= 0 && index < AppThemeMode.values.length) {
      _mode = AppThemeMode.values[index];
      notifyListeners();
    } else {
      // Si no hay valor guardado, usar modo claro por defecto
      _mode = AppThemeMode.light;
      notifyListeners();
    }
  }

  Future<void> setMode(AppThemeMode mode) async {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyThemeMode, mode.index);
  }
}
