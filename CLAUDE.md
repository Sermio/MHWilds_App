# MHWilds App

Companion app for *Monster Hunter Wilds* built with Flutter: monsters, weapons, armor sets, decorations, talismans, skills, items and maps, plus two WebView tools (Build Optimizer, Build Crafter). Game data comes from the public API `https://wilds.mhdb.io/{locale}` (docs: https://docs.wilds.mhdb.io); images are bundled under `assets/imgs/`. UI in 7 languages (ARB). Versions: see `pubspec.yaml` and `flutter --version`.

## Source layout

- `lib/main.dart` — `MultiProvider` setup and startup gate (locale, EN names cache, item icon index).
- `lib/api/` — one static class per endpoint; `api_config.dart` holds host and current API language.
- `lib/providers/` — one `ChangeNotifier` per entity (full list in memory + client-side filters), plus `LocaleProvider`, `ThemeProvider`, `EnNamesCache`.
- `lib/models/` — hand-written `fromJson` models.
- `lib/screens/` — list and detail screens; `screens/weapons_list/` holds sub-widgets split out of the weapons screens.
- `lib/components/` — shared widgets (sprite icons, chips, filters panel, sharpness bar…).
- `lib/utils/` — theme (`theme.dart`, `colors.dart`), item icon resolver, update checker, review prompt, misc helpers.
- `lib/l10n/` — ARB files; generated code in `lib/l10n/gen_l10n/` (do not edit by hand).
- `scripts/` — offline data/asset tooling (Dart and Python), not shipped.
- `docs/` — improvement plan and other notes.

## Commands

- `flutter pub get`
- `flutter analyze`
- `flutter test`
- `flutter gen-l10n` (after editing ARB files; config in `l10n.yaml`)
- `flutter run`

## Conventions

- State: Provider + `ChangeNotifier`. Read with `context.read` in callbacks, `context.watch`/`context.select` in `build`.
- Changing language invalidates every data provider (`settings.dart` → `_invalidateDataProviders`); new data providers must be added there.
- Local images are looked up by the English name (`EnNamesCache`), because the API returns translated names.
- Item icons resolve from `api kind + color` to a file in `assets/imgs/item_icons/` (`ItemIconAssetResolver`).
- User-facing strings always go through ARB/`AppLocalizations`; never hard-code text.
- Colors come from `Theme.of(context).colorScheme` or `AppColors`; avoid `Colors.white/black` (breaks dark mode). Use `withValues(alpha:)`, not `withOpacity`.
- Branches: work on `develop`, release from `main`.

## Modularity and reuse

- Before creating a widget, helper or service, search `lib/components/`, `lib/utils/` and `screens/*/` for an existing one and reuse or extend it.
- Anything used in two places becomes a shared component or helper.
- Keep files focused: split screens over ~400 lines into section widgets (see `screens/weapons_list/`).
- Keep business logic (fetching, filtering, sorting) out of widgets: it belongs in providers or plain functions that can be unit-tested.
- Every behavior change comes with a test in `test/`.

## Plan de mejoras

- Las tareas están en `docs/PLAN_MEJORAS.md` (T01…T33). Al terminar una, marca su título con ✅ en el plan y termina la respuesta con el prompt de la siguiente (respeta "Depende de"), copiado del plan en un bloque de código, indicando modelo y razonamiento.
