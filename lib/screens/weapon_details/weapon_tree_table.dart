import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/gear_sprite_icon.dart';
import 'package:mhwilds_app/components/rarity_chip.dart';
import 'package:mhwilds_app/components/sharpness_bar.dart';
import 'package:mhwilds_app/models/weapon.dart';
import 'package:mhwilds_app/screens/weapon_details/weapon_mini_stats.dart';
import 'package:mhwilds_app/screens/weapon_details/weapon_sharpness_section.dart';
import 'package:mhwilds_app/utils/game_colors.dart';
import 'package:mhwilds_app/utils/spacing.dart';
import 'package:mhwilds_app/utils/weapon_utils.dart';

/// Vista de tabla del árbol: una fila por arma de la línea de evolución.
class WeaponTreeTable extends StatelessWidget {
  const WeaponTreeTable({
    super.key,
    required this.weapons,
    required this.currentWeaponId,
    required this.onOpenWeapon,
    required this.onShowCrafting,
  });

  final List<Weapon> weapons;
  final int currentWeaponId;
  final ValueChanged<int> onOpenWeapon;
  final ValueChanged<Weapon> onShowCrafting;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: weapons.map((w) {
        final bool isCurrent = w.id == currentWeaponId;
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          decoration: BoxDecoration(
            color: isCurrent
                ? colorScheme.primaryContainer.withValues(alpha: 0.2)
                : colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  isCurrent ? colorScheme.primary : colorScheme.outlineVariant,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: isCurrent ? null : () => onOpenWeapon(w.id),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Row(
                children: [
                  GearSpriteIcon(
                    column: weaponColumnByKind[w.kind] ?? 0,
                    rarity: w.rarity,
                    size: 32,
                    fallback: Icon(WeaponUtils.getWeaponIcon(w.kind),
                        size: 24, color: GameColors.of(context).kind(w.kind)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(w.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                            ),
                            if (w.crafting.craftingMaterials.isNotEmpty ||
                                w.crafting.upgradeMaterials.isNotEmpty)
                              InkWell(
                                onTap: () => onShowCrafting(w),
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: const EdgeInsets.all(AppSpacing.xs),
                                  child: Icon(Icons.remove_red_eye,
                                      size: 18, color: colorScheme.primary),
                                ),
                              ),
                          ],
                        ),
                        if (hasSharpnessData(w.sharpness)) ...[
                          const SizedBox(height: 4),
                          SharpnessBar(
                            sharpness: w.sharpness,
                            height: 6,
                            borderRadius: 2,
                          ),
                          const SizedBox(height: 4),
                        ],
                        RarityChip(
                          rarity: w.rarity,
                          fontSize: 10,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: WeaponMiniStats(weapon: w),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
