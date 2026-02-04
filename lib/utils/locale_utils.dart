import 'package:flutter/material.dart';

/// Nombres de idioma para el selector (en su propio idioma).
/// Clave: languageCode o 'languageCode_countryCode' para variantes.
const Map<String, String> _localeDisplayNames = {
  'de': 'Deutsch',
  'en': 'English',
  'es': 'Español',
  'fr': 'Français',
  'it': 'Italiano',
  'pl': 'Polski',
  'pt': 'Português',
  'es_419': 'Español (Latinoamérica)',
  'es_ES': 'Español (España)',
  'pt_BR': 'Português (Brasil)',
};

/// Devuelve el nombre mostrado para [locale].
/// Si [locale] es null, devuelve [systemDefaultLabel] (p. ej. l10n.systemDefault).
String getLocaleDisplayName(Locale? locale, String systemDefaultLabel) {
  if (locale == null) return systemDefaultLabel;
  final key = locale.countryCode != null && locale.countryCode!.isNotEmpty
      ? '${locale.languageCode}_${locale.countryCode}'
      : locale.languageCode;
  return _localeDisplayNames[key] ?? locale.languageCode.toUpperCase();
}
