import 'package:flutter/material.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/weapon.dart';
import 'package:mhwilds_app/screens/weapon_details/crafting_costs.dart';
import 'package:mhwilds_app/screens/weapon_details/section_card.dart';
import 'package:mhwilds_app/utils/spacing.dart';

/// Sección expandible (cerrada por defecto) con materiales y costes.
class WeaponCraftingSection extends StatelessWidget {
  const WeaponCraftingSection({super.key, required this.crafting});

  final WeaponCrafting crafting;

  @override
  Widget build(BuildContext context) {
    return WeaponSectionCard(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: AppSpacing.sm),
          title: WeaponSectionTitle(
            icon: Icons.build,
            title: AppLocalizations.of(context)!.craftingMaterials,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: CraftingCostsBody(crafting: crafting),
            ),
          ],
        ),
      ),
    );
  }
}
