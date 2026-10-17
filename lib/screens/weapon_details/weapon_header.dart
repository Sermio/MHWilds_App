import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/gear_sprite_icon.dart';
import 'package:mhwilds_app/models/weapon.dart';
import 'package:mhwilds_app/utils/game_colors.dart';
import 'package:mhwilds_app/utils/spacing.dart';
import 'package:mhwilds_app/utils/weapon_utils.dart';

/// Cabecera del detalle: icono del tipo, nombre y descripción.
class WeaponHeader extends StatelessWidget {
  const WeaponHeader({super.key, required this.weapon});

  final Weapon weapon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final int? spriteColumn = weaponColumnByKind[weapon.kind];
    final fallbackIcon = Icon(
      WeaponUtils.getWeaponIcon(weapon.kind),
      color: GameColors.of(context).kind(weapon.kind),
      size: 40,
    );

    return Container(
      margin: const EdgeInsets.all(AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: spriteColumn != null
                ? GearSpriteIcon(
                    column: spriteColumn,
                    rarity: weapon.rarity,
                    size: 80,
                    fallback: fallbackIcon,
                  )
                : fallbackIcon,
          ),
          const SizedBox(height: 16),
          Text(
            weapon.name,
            style: textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold, color: colorScheme.onSurface),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          if (weapon.description.isNotEmpty)
            Text(
              weapon.description,
              style: textTheme.bodyLarge!.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.8),
                  height: 1.4),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
