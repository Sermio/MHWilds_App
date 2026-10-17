/// Configuración central de la API de MHWilds.
///
/// La URL base usa el idioma en formato ISO 639-1 (en, es, de, etc.). No hay
/// idioma global: cada petición recibe el suyo (los providers de datos lo
/// reciben de `LocaleProvider`).
class ApiConfig {
  ApiConfig._();

  /// Host base sin idioma: https://wilds.mhdb.io
  static const String host = 'https://wilds.mhdb.io';

  /// Idioma de la API cuando no se indica otro.
  static const String defaultLanguage = 'en';

  /// Código de idioma de la API para un código de idioma de la app
  /// (`pt` → `pt-BR`; null → inglés).
  static String languageFor(String? code) {
    if (code == null || code.isEmpty) return defaultLanguage;
    if (code.startsWith('pt')) return 'pt-BR';
    return code;
  }

  /// URL base para un idioma concreto: https://wilds.mhdb.io/{languageCode}
  static String baseUrlForLanguage(String languageCode) =>
      '$host/${languageCode.isEmpty ? defaultLanguage : languageCode}';
}
