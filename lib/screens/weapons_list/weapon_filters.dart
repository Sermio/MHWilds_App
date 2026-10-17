import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/gear_sprite_icon.dart';
import 'package:mhwilds_app/components/list_filters_panel.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/providers/weapons_provider.dart';
import 'package:mhwilds_app/screens/weapons_list/weapon_kind_helpers.dart';
import 'package:mhwilds_app/utils/game_colors.dart';

/// Panel de filtros de armas. El estado del filtro vive en [WeaponsProvider].
class WeaponsFiltersPanel extends StatelessWidget {
  final WeaponsProvider provider;
  final TextEditingController nameController;
  final TextEditingController seriesController;
  final VoidCallback onReset;

  const WeaponsFiltersPanel({
    super.key,
    required this.provider,
    required this.nameController,
    required this.seriesController,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return ListFiltersPanel(
      maxHeight: 340,
      title: l10n.filters,
      resetLabel: l10n.reset,
      onReset: onReset,
      fields: [
        ListFilterFieldConfig.text(
          id: 'name',
          label: l10n.searchByName,
          controller: nameController,
          onTextChanged: (query) =>
              provider.setFilter(provider.filter.copyWith(name: query)),
          hintText: l10n.enterWeaponName,
          prefixIcon: Icon(Icons.search, color: colorScheme.primary),
        ),
        ListFilterFieldConfig.text(
          id: 'series',
          label: l10n.treeSeries,
          controller: seriesController,
          onTextChanged: (query) =>
              provider.setFilter(provider.filter.copyWith(series: query)),
          hintText: l10n.enterSeriesName,
          prefixIcon: Icon(Icons.account_tree, color: colorScheme.primary),
        ),
        ListFilterFieldConfig.gridMenu(
          id: 'type',
          label: l10n.type,
          value: provider.filter.kind,
          onSelectChanged: (selectedKind) => provider.setFilter(
              provider.filter.copyWith(kind: () => selectedKind as String?)),
          options: _weaponTypeOptions(context),
        ),
        ListFilterFieldConfig.gridMenu(
          id: 'rarity',
          label: l10n.rarity,
          value: provider.filter.rarity,
          onSelectChanged: (selectedRarity) => provider.setFilter(
              provider.filter.copyWith(rarity: () => selectedRarity as int?)),
          options: _rarityOptions(context, l10n),
        ),
      ],
    );
  }

  static List<ListFilterOption> _weaponTypeOptions(BuildContext context) {
    return weaponKinds.map((kind) {
      final int? spriteColumn = weaponColumnByKind[kind];
      final icon = Icon(
        weaponKindIcon(kind),
        color: GameColors.of(context).kind(kind),
        size: 20,
      );
      return ListFilterOption(
        value: kind,
        label: weaponKindLabel(context, kind),
        leading: spriteColumn != null
            ? GearSpriteIcon(
                column: spriteColumn,
                rarity: 1,
                size: 20,
                fallback: icon,
              )
            : icon,
      );
    }).toList();
  }

  static List<ListFilterOption> _rarityOptions(
      BuildContext context, AppLocalizations l10n) {
    return [1, 2, 3, 4, 5, 6, 7, 8].map((rarity) {
      return ListFilterOption(
        value: rarity,
        label: l10n.rarityLevel(rarity),
        leading: Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: GameColors.of(context).rarity(rarity),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
    }).toList();
  }
}
