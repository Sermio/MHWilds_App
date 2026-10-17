# MHWilds App

Companion app for *Monster Hunter Wilds* built with Flutter: monsters, weapons, armor sets, decorations, talismans, skills, items and maps, plus two WebView tools (Build Optimizer, Build Crafter). Game data comes from the public API `https://wilds.mhdb.io/{locale}` (docs: https://docs.wilds.mhdb.io); images are bundled under `assets/imgs/`. UI in 7 languages (ARB). Versions: see `pubspec.yaml` and `flutter --version`.

## Source layout

- `lib/main.dart` — `MultiProvider` setup and startup gate (waits only for the saved locale and the item icon index).
- `lib/api/` — `ApiClient`, `CachedApi`/`CacheStore` (disk cache validated with `/version`), one static class per endpoint, `api_config.dart` (host, `languageFor`).
- `lib/providers/` — `CatalogProvider<T, F>` per entity (`providers/filters/` holds the immutable filters and pure `filterX` functions), `data_providers.dart` (binds them to `LocaleProvider`), `LocaleProvider`, `ThemeProvider`.
- `lib/models/` — hand-written `fromJson` models.
- `lib/screens/` — list and detail screens; `app_section.dart` is the single source of sections (title, screen, icon, AppBar actions). Big screens live in `screens/<name>/` section widgets.
- `lib/components/` — shared widgets (`SpriteIcon`, `LabelValueRow`, `AsyncListBody`, `CardSkeletonList`, filters panel…).
- `lib/utils/` — theme (`theme.dart`, `colors.dart`, `game_colors.dart`, `spacing.dart`), `text_utils.dart`, `asset_paths.dart`, item icon resolver, update checker, review prompt.
- `lib/l10n/` — ARB files; generated code in `lib/l10n/gen_l10n/` (do not edit by hand).
- `scripts/` — offline data/asset tooling (Dart and Python), not shipped.
- `docs/` — improvement plan and other notes.

## Commands

- `flutter pub get`
- `flutter analyze`
- `flutter test`
- `flutter gen-l10n` (after editing ARB files; config in `l10n.yaml`)
- `dart run scripts/generate_asset_ids.dart` (regenerates `lib/utils/asset_ids.g.dart`)
- `flutter run`

## Conventions

- State: Provider + `ChangeNotifier`. Read with `context.read` in callbacks, `context.watch`/`context.select` in `build`.
- The API language is not global: `LocaleProvider` feeds every data provider through `dataProviders()` (`ChangeNotifierProxyProvider`); new data providers must be added there. Providers keep their filter, so screens read/write it via `provider.filter`/`setFilter`.
- Monster and map images are looked up by id in `lib/utils/asset_ids.g.dart` (generated `const` maps; the API returns translated names). When new monsters/maps and their assets are added, run `dart run scripts/generate_asset_ids.dart` (needs network; warns about ids without an asset) and commit the result. Do not edit it by hand.
- Elements and status effects (icon, translated name, ailment text) come from `GameElement` (`lib/utils/game_element.dart`) and `ElementIcon`; never build `assets/imgs/elements/...` paths by hand. The API has no endpoint for them, so new ones are added to the enum, the asset folder and the ARB files.
- Item icons resolve from `api kind + color` to a file in `assets/imgs/item_icons/` (`ItemIconAssetResolver`).
- User-facing strings always go through ARB/`AppLocalizations`; never hard-code text.
- Game colors (elements, rarity, sharpness, zones) come from `GameColors.of(context)`; spacing/radius from `AppSpacing`/`AppRadius`.
- Colors come from `Theme.of(context).colorScheme` or `AppColors`; avoid `Colors.white/black` (breaks dark mode). Use `withValues(alpha:)`, not `withOpacity`.
- Branches: work on `develop`, release from `main`.

## Modularity and reuse

- Before creating a widget, helper or service, search `lib/components/`, `lib/utils/` and `screens/*/` for an existing one and reuse or extend it.
- Anything used in two places becomes a shared component or helper.
- Keep files focused: split screens over ~400 lines into section widgets (see `screens/weapons_list/`).
- Keep business logic (fetching, filtering, sorting) out of widgets: it belongs in providers or plain functions that can be unit-tested.
- Every behavior change comes with a test in `test/`.

## Plan de mejoras

- Las tareas están en `docs/PLAN_MEJORAS.md` (T01…T41). Al terminar una, marca su título con ✅ en el plan y termina la respuesta con el prompt de la siguiente (respeta "Depende de"), copiado del plan en un bloque de código, indicando modelo y razonamiento.
