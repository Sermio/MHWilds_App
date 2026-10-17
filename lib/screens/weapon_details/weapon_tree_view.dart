import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/gear_sprite_icon.dart';
import 'package:mhwilds_app/components/rarity_chip.dart';
import 'package:mhwilds_app/components/sharpness_bar.dart';
import 'package:mhwilds_app/components/tree_connector_painter.dart';
import 'package:mhwilds_app/screens/weapon_details/weapon_mini_stats.dart';
import 'package:mhwilds_app/screens/weapon_details/weapon_sharpness_section.dart';
import 'package:mhwilds_app/utils/game_colors.dart';
import 'package:mhwilds_app/utils/spacing.dart';
import 'package:mhwilds_app/utils/weapon_tree_builder.dart';
import 'package:mhwilds_app/utils/weapon_utils.dart';

/// Árbol de evolución con líneas conectoras; [currentWeaponId] se resalta.
class WeaponVisualTree extends StatelessWidget {
  const WeaponVisualTree({
    super.key,
    required this.node,
    required this.currentWeaponId,
    required this.onOpenWeapon,
    this.depth = 0,
    this.isLastChildPath = const [],
  });

  final TreeNode node;
  final int currentWeaponId;
  final ValueChanged<int> onOpenWeapon;
  final int depth;
  final List<bool> isLastChildPath;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isCurrentWeapon = node.weapon.id == currentWeaponId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Líneas de los niveles anteriores
              for (int i = 0; i < depth - 1; i++)
                SizedBox(
                  width: 24,
                  child: isLastChildPath[i]
                      ? null
                      : CustomPaint(
                          painter: StraightLinePainter(
                            color: colorScheme.outlineVariant,
                          ),
                        ),
                ),
              // Línea del nivel actual
              if (depth > 0)
                SizedBox(
                  width: 24,
                  child: CustomPaint(
                    painter: TreeConnectorPainter(
                      isLastChild: isLastChildPath.last,
                      color: colorScheme.outlineVariant,
                    ),
                  ),
                ),
              // Contenido del nodo
              Container(
                margin: const EdgeInsets.only(
                    bottom: AppSpacing.xs,
                    top: AppSpacing.xs,
                    left: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: isCurrentWeapon
                      ? colorScheme.primaryContainer.withValues(alpha: 0.3)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: isCurrentWeapon
                      ? Border.all(color: colorScheme.primary, width: 1)
                      : null,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    if (!isCurrentWeapon) {
                      onOpenWeapon(node.weapon.id);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm, vertical: 6),
                    child: Row(
                      children: [
                        GearSpriteIcon(
                          column: weaponColumnByKind[node.weapon.kind] ?? 0,
                          rarity: node.weapon.rarity,
                          size: 24,
                          fallback: Icon(
                            WeaponUtils.getWeaponIcon(node.weapon.kind),
                            color:
                                GameColors.of(context).kind(node.weapon.kind),
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 140,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                node.weapon.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontWeight: isCurrentWeapon
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                        color: isCurrentWeapon
                                            ? colorScheme.primary
                                            : colorScheme.onSurface),
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (hasSharpnessData(node.weapon.sharpness)) ...[
                                const SizedBox(height: 4),
                                SizedBox(
                                  width: 80,
                                  child: SharpnessBar(
                                    sharpness: node.weapon.sharpness,
                                    height: 6,
                                    borderRadius: 2,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 4),
                              RarityChip(
                                rarity: node.weapon.rarity,
                                fontSize: 10,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        WeaponMiniStats(weapon: node.weapon),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        for (final (index, child) in node.children.indexed)
          WeaponVisualTree(
            node: child,
            currentWeaponId: currentWeaponId,
            onOpenWeapon: onOpenWeapon,
            depth: depth + 1,
            isLastChildPath: [
              ...isLastChildPath,
              index == node.children.length - 1,
            ],
          ),
      ],
    );
  }
}
