/// Configuración central de la API de MHWilds.
///
/// La URL base usa el idioma en formato ISO 639-1 (en, es, de, etc.).
/// [languageCode] se sincroniza con el idioma de la app (LocaleProvider)
/// para que los datos de la API se pidan en el mismo idioma que la interfaz.
class ApiConfig {
  ApiConfig._();

  /// Host base sin idioma: https://wilds.mhdb.io
  static const String host = 'https://wilds.mhdb.io';

  static String _languageCode = 'en';

  /// Código de idioma ISO 639-1 usado en las peticiones a la API.
  /// Debe asignarse desde la app (p. ej. desde [LocaleProvider.locale?.languageCode]).
  static set languageCode(String? code) {
    _languageCode = code ?? 'en';
  }

  static String get languageCode => _languageCode;

  /// URL base con idioma: https://wilds.mhdb.io/{languageCode}
  static String get baseUrl => '$host/$_languageCode';

  /// URL base para un idioma concreto (sin cambiar [languageCode]).
  /// Útil para peticiones que siempre deben ir en un idioma fijo (p. ej. imágenes en EN).
  static String baseUrlForLanguage(String languageCode) =>
      '$host/${languageCode.isEmpty ? "en" : languageCode}';

  /// Construye la URL completa para un path (sin barra inicial).
  /// Ejemplo: url('monsters') => https://wilds.mhdb.io/en/monsters
  static String url(String path) {
    final p = path.startsWith('/') ? path.substring(1) : path;
    return '$baseUrl/$p';
  }
}
