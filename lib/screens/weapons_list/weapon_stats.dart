import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/label_value_row.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/weapon.dart';
import 'package:mhwilds_app/screens/weapons_list/display_utils.dart';
import 'package:mhwilds_app/screens/weapons_list/weapon_kind_helpers.dart';

/// Estadísticas principales de la tarjeta de arma (daño, afinidad, etc.).
class WeaponStats extends StatelessWidget {
  final Weapon weapon;

  const WeaponStats({super.key, required this.weapon});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    Widget statRow(String label, String value, IconData icon, Color iconColor) {
      return LabelValueRow(
        label: Text(
          label,
          style: textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withValues(alpha: 0.8)),
        ),
        value: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold, color: colorScheme.onSurface),
            ),
            const SizedBox(width: 4),
            Icon(icon, size: 16, color: iconColor),
          ],
        ),
      );
    }

    const gap = SizedBox(height: 12);
    final additionalInfo =
        WeaponDisplayUtils.buildAdditionalDamageInfo(context, weapon);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        statRow('${l10n.physicalDamage}:', '${weapon.damage.display}',
            Icons.gps_fixed, Colors.red[400]!),
        gap,
        statRow(
            '${l10n.affinity}:',
            '${weapon.affinity > 0 ? '+' : ''}${weapon.affinity}%',
            Icons.trending_up,
            colorScheme.primary),
        if (weapon.specials != null && weaponHasElementalDamage(weapon)) ...[
          gap,
          WeaponDisplayUtils.buildElementalDamageRow(context, weapon),
        ],
        if (additionalInfo is! SizedBox) ...[gap, additionalInfo],
        if (weapon.defenseBonus > 0) ...[
          gap,
          statRow('${l10n.defense}:', '+${weapon.defenseBonus}', Icons.shield,
              colorScheme.primary),
        ],
        if (weapon.elderseal != null) ...[
          gap,
          statRow(
              'Elderseal:',
              weapon.elderseal![0].toUpperCase() +
                  weapon.elderseal!.substring(1),
              Icons.auto_awesome,
              colorScheme.primary),
        ],
      ],
    );
  }
}
