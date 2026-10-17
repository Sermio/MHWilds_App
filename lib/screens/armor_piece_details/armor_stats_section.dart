import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/label_value_row.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/armor_piece.dart' as armor_models;
import 'package:mhwilds_app/screens/armor_piece_details/armor_base_defense.dart';
import 'package:mhwilds_app/screens/armor_piece_details/armor_piece_slots_widget.dart';
import 'package:mhwilds_app/screens/armor_piece_details/armor_resistances_widget.dart';
import 'package:mhwilds_app/screens/armor_piece_details/armor_section_card.dart';
import 'package:mhwilds_app/utils/game_colors.dart';

/// Sección de estadísticas: rareza, rango, ranuras, defensa y resistencias.
class ArmorStatsSection extends StatelessWidget {
  final armor_models.ArmorPiece armor;

  const ArmorStatsSection({super.key, required this.armor});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final rarityColor = GameColors.of(context).rarity(armor.rarity);
    final rank = armor.rank.isNotEmpty
        ? armor.rank[0].toUpperCase() + armor.rank.substring(1).toLowerCase()
        : '';
    return ArmorSectionCard(
      icon: Icons.analytics,
      title: l10n.statistics,
      child: Column(
        children: [
          _StatRow(
            title: l10n.rarity,
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: rarityColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: rarityColor.withValues(alpha: 0.3)),
              ),
              child: Text(
                armor.rarity.toString(),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold, color: rarityColor),
              ),
            ),
          ),
          const Divider(height: 24),
          _StatRow(title: l10n.rank, value: rank),
          const Divider(height: 24),
          _StatRow(
              title: l10n.slots,
              trailing: ArmorPieceSlotsWidget(armorPiece: armor)),
          const Divider(height: 24),
          _StatRow(
            title: l10n.baseDefense,
            value: '${armor.defense['base']}',
            trailing: ArmorBaseDefense(baseDefense: armor.defense['base']!),
          ),
          const Divider(height: 24),
          ArmorResistancesWidget(armor: armor),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String title;
  final String value;
  final Widget? trailing;

  const _StatRow({required this.title, this.value = '', this.trailing});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return LabelValueRow(
      label: Text(
        '$title:',
        style: textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withValues(alpha: 0.8)),
      ),
      value: trailing ??
          Text(
            value,
            style: textTheme.bodyLarge!.copyWith(
                color: colorScheme.onSurface, fontWeight: FontWeight.w500),
          ),
    );
  }
}
