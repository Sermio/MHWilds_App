import 'package:flutter/material.dart';
import 'package:mhwilds_app/models/weapon.dart';
import 'package:mhwilds_app/utils/game_colors.dart';
import 'package:mhwilds_app/utils/weapon_utils.dart';

/// Daño, afinidad y daño elemental resumidos en una línea (árbol y tabla).
class WeaponMiniStats extends StatelessWidget {
  const WeaponMiniStats({super.key, required this.weapon});

  final Weapon weapon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final valueStyle = Theme.of(context)
        .textTheme
        .bodySmall!
        .copyWith(fontWeight: FontWeight.bold);

    WeaponSpecial? special;
    final specialsList = weapon.specials;
    if (specialsList is List && specialsList.isNotEmpty) {
      try {
        special =
            WeaponSpecial.fromJson(specialsList[0] as Map<String, dynamic>);
      } catch (_) {}
    }

    return Wrap(
      spacing: 6,
      runSpacing: 4,
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _MiniStat(
          icon: Icons.gps_fixed,
          color: Colors.red[400],
          text: '${weapon.damage.display}',
          style: valueStyle,
        ),
        if (weapon.affinity != 0)
          _MiniStat(
            icon: Icons.trending_up,
            color: colorScheme.primary,
            text: '${weapon.affinity}%',
            style: valueStyle,
          ),
        if (special != null && special.damage.display > 0)
          _MiniStat(
            icon: WeaponUtils.getElementIcon(special.element),
            color: GameColors.of(context).element(special.element),
            text: '${special.damage.display}',
            style: valueStyle,
          ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.icon,
    required this.color,
    required this.text,
    required this.style,
  });

  final IconData icon;
  final Color? color;
  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 2),
        Text(text, style: style),
      ],
    );
  }
}
