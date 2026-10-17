import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/gear_sprite_icon.dart';
import 'package:mhwilds_app/components/rarity_chip.dart';
import 'package:mhwilds_app/components/sharpness_bar.dart';
import 'package:mhwilds_app/components/tree_connector_painter.dart';
import 'package:mhwilds_app/models/weapon.dart';
import 'package:mhwilds_app/screens/weapon_details.dart';
import 'package:mhwilds_app/screens/weapons_list/weapon_kind_helpers.dart';
import 'package:mhwilds_app/utils/game_colors.dart';
import 'package:mhwilds_app/utils/spacing.dart';
import 'package:mhwilds_app/utils/weapon_tree_builder.dart';

/// Construye los árboles de crafteo (raíces) de las armas de una serie.
List<TreeNode> buildSeriesTrees(List<Weapon> seriesWeapons) {
  final roots = seriesWeapons.where((w) {
    if (w.crafting.previous == null) return true;
    return !seriesWeapons.any((other) => other.id == w.crafting.previous?.id);
  }).toList();

  TreeNode buildNode(Weapon w) {
    final children = seriesWeapons
        .where((child) => child.crafting.previous?.id == w.id)
        .toList();
    return TreeNode(
      weapon: w,
      children: children.map((c) => buildNode(c)).toList(),
    );
  }

  return roots.map((r) => buildNode(r)).toList();
}

/// Agrupa las armas por nombre de serie (usa [noSeriesLabel] si no tiene).
Map<String, List<Weapon>> groupWeaponsBySeries(
    List<Weapon> weapons, String noSeriesLabel) {
  final Map<String, List<Weapon>> groups = {};
  for (final w in weapons) {
    final seriesName = w.series?.name ?? noSeriesLabel;
    groups.putIfAbsent(seriesName, () => []).add(w);
  }
  return groups;
}

/// Tarjeta desplegable de una serie con su árbol de armas.
class WeaponSeriesTile extends StatelessWidget {
  final String seriesName;
  final List<Weapon> weapons;
  final bool initiallyExpanded;

  const WeaponSeriesTile({
    super.key,
    required this.seriesName,
    required this.weapons,
    required this.initiallyExpanded,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final roots = buildSeriesTrees(weapons);

    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        // Claves propias: sin ellas, el ExpansionTile (guarda un bool) y el
        // scroll de dentro (guarda un double) comparten hueco en PageStorage.
        child: ExpansionTile(
          key: PageStorageKey('series-tile-$seriesName'),
          initiallyExpanded: initiallyExpanded,
          collapsedBackgroundColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg)),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg)),
          tilePadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
          title: Row(
            children: [
              Icon(Icons.account_tree_outlined,
                  size: 20, color: colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  seriesName,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${weapons.length}',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold, color: colorScheme.primary),
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  bottom: AppSpacing.xl,
                  left: AppSpacing.sm,
                  right: AppSpacing.sm,
                  top: AppSpacing.sm),
              child: SingleChildScrollView(
                key: PageStorageKey('series-scroll-$seriesName'),
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: roots
                      .map((node) => WeaponTreeNodeView(node: node))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Nodo del árbol de crafteo (recursivo): conectores + mini tarjeta del arma.
class WeaponTreeNodeView extends StatelessWidget {
  final TreeNode node;
  final int depth;
  final List<bool> isLastChildPath;

  const WeaponTreeNodeView({
    super.key,
    required this.node,
    this.depth = 0,
    this.isLastChildPath = const [],
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final weapon = node.weapon;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              Container(
                margin: const EdgeInsets.only(
                    bottom: AppSpacing.xs,
                    top: AppSpacing.xs,
                    left: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WeaponDetails(weapon: weapon)),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: _NodeContent(weapon: weapon),
                  ),
                ),
              ),
            ],
          ),
        ),
        for (final entry in node.children.asMap().entries)
          WeaponTreeNodeView(
            node: entry.value,
            depth: depth + 1,
            isLastChildPath: [
              ...isLastChildPath,
              entry.key == node.children.length - 1,
            ],
          ),
      ],
    );
  }
}

class _NodeContent extends StatelessWidget {
  final Weapon weapon;

  const _NodeContent({required this.weapon});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bodySmallBold = Theme.of(context)
        .textTheme
        .bodySmall!
        .copyWith(fontWeight: FontWeight.bold);

    return Row(
      children: [
        GearSpriteIcon(
          column: weaponColumnByKind[weapon.kind] ?? 0,
          rarity: weapon.rarity,
          size: 32,
          fallback: Icon(weaponKindIcon(weapon.kind),
              size: 24, color: GameColors.of(context).kind(weapon.kind)),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 140,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(weapon.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13)),
              if (weaponHasSharpnessData(weapon)) ...[
                const SizedBox(height: 4),
                SharpnessBar(
                  sharpness: weapon.sharpness,
                  height: 6,
                  borderRadius: 2,
                ),
                const SizedBox(height: 4),
              ],
              RarityChip(
                rarity: weapon.rarity,
                fontSize: 10,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 70,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.gps_fixed, size: 14, color: Colors.red[400]),
                  const SizedBox(width: 2),
                  Text('${weapon.damage.display}', style: bodySmallBold),
                ],
              ),
              if (weapon.affinity != 0) ...[
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.trending_up,
                        size: 14, color: colorScheme.primary),
                    const SizedBox(width: 2),
                    Text('${weapon.affinity}%', style: bodySmallBold),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
