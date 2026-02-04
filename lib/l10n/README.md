# Internacionalización (i18n)

## Idiomas soportados

| Código | Idioma                  |
| ------ | ----------------------- |
| en     | English                 |
| fr     | French                  |
| it     | Italian                 |
| de     | German                  |
| es     | Spanish (genérico)      |
| es_ES  | Spanish (Spain)         |
| es_419 | Spanish (Latin America) |
| pt_BR  | Portuguese (Brazil)     |
| pl     | Polish                  |

## Estructura

- **`app_<locale>.arb`** – Cadenas por idioma (p. ej. `app_en.arb`, `app_fr.arb`, `app_es_ES.arb`).
- **`gen_l10n/`** – Código generado: `app_localizations.dart` y `app_localizations_<locale>.dart`.

## Añadir nuevas cadenas

1. Añade la clave en **`app_en.arb`** (y en el resto de idiomas en sus `.arb`).
2. Si usas el generador: ejecuta `flutter gen-l10n` y actualiza los imports si cambia algo.
3. Si mantienes el archivo manual: añade la clave en el mapa `_localizedValues` y el getter en la clase `AppLocalizations` en `gen_l10n/app_localizations.dart`.

## Uso en la app

```dart
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';

// En un widget con BuildContext:
final l10n = AppLocalizations.of(context)!;
Text(l10n.appTitle);
Text(l10n.settings);
```

## Cambiar idioma

El idioma se controla con `LocaleProvider` (en ajustes o donde quieras):

```dart
context.read<LocaleProvider>().setLocale(const Locale('es'));
context.read<LocaleProvider>().setLocale(null);  // usar idioma del sistema
```
