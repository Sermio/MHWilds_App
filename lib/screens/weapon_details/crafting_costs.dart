import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/material_cost_widgets.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/weapon.dart';

/// Indica si el arma tiene materiales o costes de crafteo/mejora.
bool hasCraftingData(WeaponCrafting c) {
  return c.craftingMaterials.isNotEmpty ||
      c.upgradeMaterials.isNotEmpty ||
      c.craftingZennyCost > 0 ||
      c.upgradeZennyCost > 0;
}

/// Materiales de crafteo y mejora más los costes en zenny. Lo comparten la
/// sección expandible y el modal de la tabla del árbol.
class CraftingCostsBody extends StatelessWidget {
  const CraftingCostsBody({
    super.key,
    required this.crafting,
    this.stretch = false,
  });

  final WeaponCrafting crafting;

  /// Ocupa todo el ancho (modal) en lugar de centrar el contenido.
  final bool stretch;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasMaterialRows = crafting.craftingMaterials.isNotEmpty ||
        crafting.upgradeMaterials.isNotEmpty;

    return Column(
      crossAxisAlignment:
          stretch ? CrossAxisAlignment.stretch : CrossAxisAlignment.center,
      children: [
        if (crafting.craftingMaterials.isNotEmpty) ...[
          CostLabel(l10n.craft),
          const SizedBox(height: 8),
          MaterialCostTable(materials: crafting.craftingMaterials),
        ],
        if (crafting.craftingMaterials.isNotEmpty &&
            crafting.upgradeMaterials.isNotEmpty)
          const SizedBox(height: 16),
        if (crafting.upgradeMaterials.isNotEmpty) ...[
          CostLabel(l10n.upgrade),
          const SizedBox(height: 8),
          MaterialCostTable(materials: crafting.upgradeMaterials),
        ],
        if (crafting.craftingZennyCost > 0 ||
            crafting.upgradeZennyCost > 0) ...[
          const SizedBox(height: 20),
          // Sin materiales: ancho completo para centrar los chips. Con
          // materiales: Wrap estrecho que la Column centra.
          () {
            final wrap = Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                if (crafting.craftingZennyCost > 0)
                  ZennyCostChip(label: l10n.craft, cost: crafting.craftingZennyCost),
                if (crafting.upgradeZennyCost > 0)
                  ZennyCostChip(
                      label: l10n.upgrade, cost: crafting.upgradeZennyCost),
              ],
            );
            if (hasMaterialRows && !stretch) return wrap;
            return SizedBox(width: double.infinity, child: wrap);
          }(),
        ],
      ],
    );
  }
}

class CostLabel extends StatelessWidget {
  const CostLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
