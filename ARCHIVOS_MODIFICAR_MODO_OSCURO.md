# Archivos a modificar para modo oscuro (Opción A)

## Hecho en esta implementación

- **Nuevo:** `lib/providers/theme_provider.dart` — Provider claro/oscuro/sistema + SharedPreferences
- **main.dart:** ThemeProvider, theme + darkTheme, themeMode
- **pubspec.yaml:** shared_preferences
- **theme.dart:** lightTheme + darkTheme con ColorScheme
- **update_checker.dart:** Theme.of(ctx).colorScheme para icono y botón
- **custom_card.dart:** backgroundColor opcional, default desde colorScheme.surfaceContainerHighest
- **c_drawer.dart:** colorScheme en todo + selector de tema (light/dark/system) al final del drawer
- **c_chip.dart:** colorScheme.shadow, colorScheme.onSurface
- **sharpness_bar.dart:** colorScheme.outline, colorScheme.shadow
- **items_list.dart:** migrado a Theme.of(context).colorScheme en scaffold, filtros, lista, FAB, \_buildRecipesSection
- **monsters_list.dart:** migrado igual que items_list (colorScheme en build, filtros, lista, FAB, \_buildLocationsSection, \_buildWeaknessesSection)

## Pendiente (mismo patrón: colorScheme al inicio de build, reemplazar Colors.xxx / AppColors por colorScheme)

- **Utils:** `lib/utils/utils.dart`, `lib/utils/weapon_utils.dart` (solo bordes/sombras si los hay; colores de elementos/armas pueden quedar fijos)
- **Componentes:** `c_appbar.dart`, `monster_details_card.dart`, `elements_dialog.dart`, `url_image_loader.dart`, `c_preview_container.dart`
- **Pantallas listas:** `decorations_list.dart`, `weapons_list.dart`, `talismans_list.dart`, `skills_list.dart`, `armor_sets_list.dart`
- **Pantallas detalles:** `monster_details.dart`, `weapon_details.dart`, `skill_details.dart`, `map_details.dart`, `item_details.dart`, `armor_piece_details.dart`

Patrón: al inicio de `build(context)` poner `final colorScheme = Theme.of(context).colorScheme;` y sustituir:

- `Colors.white` → `colorScheme.surface`
- `Colors.grey[50]` → `colorScheme.surfaceContainerHighest`
- `Colors.black87` / `Colors.black` (texto) → `colorScheme.onSurface` o `colorScheme.onPrimary` en botones
- `Colors.grey[300]` etc. → `colorScheme.outlineVariant` o `colorScheme.onSurface.withOpacity(0.x)`
- `AppColors.goldSoft` (UI) → `colorScheme.primary`
- FAB/buttons: `colorScheme.primary`, `colorScheme.onPrimary`
