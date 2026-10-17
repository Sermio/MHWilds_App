import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/element_icon.dart';
import 'package:mhwilds_app/components/gear_sprite_icon.dart';
import 'package:mhwilds_app/components/list_filters_panel.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/providers/filters/armor_set_filter.dart';
import 'package:mhwilds_app/utils/game_colors.dart';
import 'package:mhwilds_app/utils/game_element.dart';

/// Panel de filtros (nombre, tipo, rareza, resistencia) de la lista de sets de armadura.
class ArmorSetFiltersPanel extends StatelessWidget {
  final ArmorSetFilter filter;
  final TextEditingController nameController;
  final ValueChanged<ArmorSetFilter> onFilterChanged;
  final VoidCallback onReset;

  const ArmorSetFiltersPanel({
    super.key,
    required this.filter,
    required this.nameController,
    required this.onFilterChanged,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return ListFiltersPanel(
      maxHeight: 440,
      title: l10n.filters,
      resetLabel: l10n.reset,
      onReset: onReset,
      fields: [
        ListFilterFieldConfig.text(
          id: 'name',
          label: l10n.searchByName,
          controller: nameController,
          onTextChanged: (query) =>
              onFilterChanged(filter.copyWith(name: query)),
          hintText: l10n.enterArmorSetName,
          prefixIcon: Icon(Icons.search, color: colorScheme.primary),
        ),
        ListFilterFieldConfig.gridMenu(
          id: 'type',
          label: l10n.type,
          value: filter.kind,
          onSelectChanged: (selectedKind) => onFilterChanged(
              filter.copyWith(kind: () => selectedKind as String?)),
          options: _armorTypeOptions(context),
        ),
        ListFilterFieldConfig.gridMenu(
          id: 'rarity',
          label: l10n.rarity,
          value: filter.rarity,
          onSelectChanged: (selectedRarity) => onFilterChanged(
              filter.copyWith(rarity: () => selectedRarity as int?)),
          options: _rarityOptions(context, l10n),
        ),
        ListFilterFieldConfig.select(
          id: 'element',
          label: l10n.resistances,
          value: filter.element,
          onSelectChanged: (selected) => onFilterChanged(
              filter.copyWith(element: () => selected as String?)),
          options: _elementOptions(l10n),
        ),
      ],
    );
  }

  /// Solo elementos: las armaduras no resisten estados.
  List<ListFilterOption> _elementOptions(AppLocalizations l10n) {
    return [
      for (final e in GameElement.elements)
        ListFilterOption(
          value: e.id,
          label: e.label(l10n),
          leading: ElementIcon(e.id, size: 20),
        ),
    ];
  }

  List<ListFilterOption> _armorTypeOptions(BuildContext context) {
    final gameColors = GameColors.of(context);
    return ['head', 'chest', 'arms', 'waist', 'legs'].map((kind) {
      final int? spriteColumn = armorColumnByKind[kind];
      final Widget shield =
          Icon(Icons.shield, color: gameColors.kind(kind), size: 20);
      return ListFilterOption(
        value: kind,
        label: armorSlotLabel(context, kind),
        leading: spriteColumn != null
            ? GearSpriteIcon(
                column: spriteColumn,
                rarity: 1,
                size: 20,
                fallback: shield,
              )
            : shield,
      );
    }).toList();
  }

  List<ListFilterOption> _rarityOptions(
      BuildContext context, AppLocalizations l10n) {
    final gameColors = GameColors.of(context);
    return [1, 2, 3, 4, 5, 6, 7, 8].map((rarity) {
      return ListFilterOption(
        value: rarity,
        label: l10n.rarityLevel(rarity),
        leading: Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: gameColors.rarity(rarity),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
    }).toList();
  }
}

/// Etiqueta localizada de la pieza de armadura según su tipo.
String armorSlotLabel(BuildContext context, String slot) {
  final l10n = AppLocalizations.of(context)!;
  switch (slot) {
    case 'head':
      return l10n.armorSlotHead;
    case 'chest':
      return l10n.armorSlotChest;
    case 'arms':
      return l10n.armorSlotArms;
    case 'waist':
      return l10n.armorSlotWaist;
    case 'legs':
      return l10n.armorSlotLegs;
    default:
      return slot;
  }
}
