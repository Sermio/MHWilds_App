import 'package:flutter/material.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/weapon.dart';
import 'package:mhwilds_app/screens/weapon_details/section_card.dart';
import 'package:mhwilds_app/screens/weapon_details/weapon_tree_table.dart';
import 'package:mhwilds_app/screens/weapon_details/weapon_tree_view.dart';
import 'package:mhwilds_app/utils/spacing.dart';
import 'package:mhwilds_app/utils/weapon_tree_builder.dart';

/// Sección expandible con el árbol de armas, alternable entre árbol y tabla.
/// El estado de la vista vive en el padre ([isTreeView] / [onViewChanged]).
class WeaponTreeSection extends StatelessWidget {
  const WeaponTreeSection({
    super.key,
    required this.rootNode,
    required this.currentWeaponId,
    required this.isTreeView,
    required this.onViewChanged,
    required this.onOpenWeapon,
    required this.onShowCrafting,
  });

  final TreeNode rootNode;
  final int currentWeaponId;
  final bool isTreeView;
  final ValueChanged<bool> onViewChanged;
  final ValueChanged<int> onOpenWeapon;
  final ValueChanged<Weapon> onShowCrafting;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    return WeaponSectionCard(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          tilePadding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: AppSpacing.sm),
          title: WeaponSectionTitle(
            icon: Icons.account_tree,
            title: l10n?.weaponTree ?? 'Weapon Tree',
            fill: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.account_tree,
                      color: isTreeView
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant),
                  onPressed: () => onViewChanged(true),
                  tooltip: l10n?.treeViewTooltip ?? 'Tree View',
                ),
                IconButton(
                  icon: Icon(Icons.table_rows,
                      color: !isTreeView
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant),
                  onPressed: () => onViewChanged(false),
                  tooltip: l10n?.tableViewTooltip ?? 'Table View',
                ),
              ],
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: isTreeView
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: WeaponVisualTree(
                        node: rootNode,
                        currentWeaponId: currentWeaponId,
                        onOpenWeapon: onOpenWeapon,
                      ),
                    )
                  : WeaponTreeTable(
                      weapons: WeaponTreeBuilder.flattenTree(rootNode),
                      currentWeaponId: currentWeaponId,
                      onOpenWeapon: onOpenWeapon,
                      onShowCrafting: onShowCrafting,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
