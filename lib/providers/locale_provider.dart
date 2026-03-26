import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _keyLocale = 'app_locale';
const String _systemLocaleSentinel = 'system';

/// Provider que guarda el idioma actual de la app (es, en, etc.)
/// y lo persiste en SharedPreferences.
class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  final Completer<void> _localeReadyCompleter = Completer<void>();

  /// Completa cuando se ha leído el idioma guardado (o se ha decidido usar el del sistema).
  /// Esperar a este Future antes de mostrar la UI evita que la primera petición use el idioma equivocado.
  Future<void> get localeReady => _localeReadyCompleter.future;

  /// Idioma actual (siempre controlado por la app; no depende del sistema).
  Locale get locale => _locale;

  LocaleProvider() {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_keyLocale);
      if (saved == null) {
        // Idioma por defecto si el usuario aún no ha elegido uno.
        _locale = const Locale('en');
        notifyListeners();
        return;
      }

      // Compatibilidad: versiones anteriores permitían "system". Ahora se fuerza
      // a un idioma de la app para no depender del dispositivo.
      if (saved == _systemLocaleSentinel || saved.isEmpty) {
        _locale = const Locale('en');
        notifyListeners();
        return;
      }

      final parts = saved.split('_');
      _locale = parts.length > 1 ? Locale(parts[0], parts[1]) : Locale(parts[0]);
      notifyListeners();
    } finally {
      if (!_localeReadyCompleter.isCompleted) {
        _localeReadyCompleter.complete();
      }
    }
  }

  /// Cambia el idioma (solo idiomas seleccionables dentro de la app).
  /// Se persiste en SharedPreferences (idioma + variante si existe, p. ej. pt_BR).
  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final value = locale.countryCode != null && locale.countryCode!.isNotEmpty
        ? '${locale.languageCode}_${locale.countryCode}'
        : locale.languageCode;
    await prefs.setString(_keyLocale, value);
  }
}
