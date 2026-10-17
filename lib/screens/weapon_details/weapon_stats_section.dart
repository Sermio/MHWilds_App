import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/stat_row.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/weapon.dart';
import 'package:mhwilds_app/screens/weapon_details/section_card.dart';
import 'package:mhwilds_app/screens/weapon_details/weapon_slots.dart';
import 'package:mhwilds_app/screens/weapons_list.dart';
import 'package:mhwilds_app/utils/game_colors.dart';

/// Estadísticas principales: rareza, daño, afinidad, defensa, huecos y
/// datos específicos del tipo de arma.
class WeaponStatsSection extends StatelessWidget {
  const WeaponStatsSection({super.key, required this.weapon});

  final Weapon weapon;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final rarityColor = GameColors.of(context).rarity(weapon.rarity);

    return WeaponTitledCard(
      icon: Icons.analytics,
      title: l10n.statistics,
      // stretch: sin él cada fila se encoge a su contenido y queda centrada.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StatRow(
            title: l10n.rarity,
            value: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: rarityColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: rarityColor.withValues(alpha: 0.3)),
              ),
              child: Text(
                weapon.rarity.toString(),
                style: textTheme.bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold, color: rarityColor),
              ),
            ),
          ),
          const Divider(height: 24),
          StatRow(
            title: l10n.physicalDamage,
            value: _IconValue(
              text: '${weapon.damage.display}',
              bold: true,
              icon: Icons.gps_fixed,
              iconColor: Colors.red[400],
            ),
          ),
          const Divider(height: 24),
          StatRow(
            title: l10n.affinity,
            value: _IconValue(
              text: '${weapon.affinity > 0 ? '+' : ''}${weapon.affinity}%',
              icon: Icons.trending_up,
              iconColor: colorScheme.primary,
            ),
          ),
          if (weapon.defenseBonus > 0) ...[
            const Divider(height: 24),
            StatRow(
              title: l10n.defenseBonus,
              value: _IconValue(
                text: '+${weapon.defenseBonus}',
                icon: Icons.shield,
                iconColor: colorScheme.primary,
              ),
            ),
          ],
          if (weapon.elderseal != null) ...[
            const Divider(height: 24),
            StatRow(
              title: l10n.elderseal,
              value: _IconValue(
                text: weapon.elderseal![0].toUpperCase() +
                    weapon.elderseal!.substring(1),
                icon: Icons.auto_awesome,
                iconColor: colorScheme.primary,
              ),
            ),
          ],
          if (weapon.slots.isNotEmpty) ...[
            const Divider(height: 24),
            StatRow(title: l10n.slots, value: WeaponSlots(slots: weapon.slots)),
          ],
          ..._typeSpecificStats(context),
        ],
      ),
    );
  }

  /// Daño elemental/estado y datos propios del tipo de arma, si los hay.
  List<Widget> _typeSpecificStats(BuildContext context) {
    final stats = <Widget>[];
    final elementalStats = WeaponDisplayUtils.buildElementalDamageRow(
        context, weapon,
        isDetailView: true);
    if (elementalStats is! SizedBox) {
      stats.add(const Divider(height: 24));
      stats.add(elementalStats);
    }
    final additionalInfo = WeaponDisplayUtils.buildAdditionalDamageInfo(
        context, weapon,
        isDetailView: true);
    if (additionalInfo is! SizedBox) {
      stats.add(const Divider(height: 24));
      stats.add(additionalInfo);
    }
    return stats;
  }
}

class _IconValue extends StatelessWidget {
  const _IconValue({
    required this.text,
    required this.icon,
    required this.iconColor,
    this.bold = false,
  });

  final String text;
  final IconData icon;
  final Color? iconColor;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface),
        ),
        const SizedBox(width: 4),
        Icon(icon, size: 18, color: iconColor),
      ],
    );
  }
}
