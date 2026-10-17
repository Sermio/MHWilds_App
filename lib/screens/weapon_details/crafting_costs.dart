import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/material_image.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/armor_piece.dart' as armor_models;
import 'package:mhwilds_app/models/weapon.dart';
import 'package:mhwilds_app/screens/item_details.dart';
import 'package:mhwilds_app/utils/spacing.dart';

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
          MaterialsList(materials: crafting.craftingMaterials),
        ],
        if (crafting.craftingMaterials.isNotEmpty &&
            crafting.upgradeMaterials.isNotEmpty)
          const SizedBox(height: 16),
        if (crafting.upgradeMaterials.isNotEmpty) ...[
          CostLabel(l10n.upgrade),
          const SizedBox(height: 8),
          MaterialsList(materials: crafting.upgradeMaterials),
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
                  CostChip(label: l10n.craft, cost: crafting.craftingZennyCost),
                if (crafting.upgradeZennyCost > 0)
                  CostChip(
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

class MaterialsList extends StatelessWidget {
  const MaterialsList({super.key, required this.materials});

  final List<armor_models.Material> materials;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final material in materials) MaterialTile(material: material),
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

class MaterialTile extends StatelessWidget {
  const MaterialTile({super.key, required this.material});

  final armor_models.Material material;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemDetails(item: material.item),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: MaterialImage(
                      item: material.item,
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    material.item.name,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface),
                  ),
                ),
                Text(
                  'x${material.quantity}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CostChip extends StatelessWidget {
  const CostChip({super.key, required this.label, required this.cost});

  final String label;
  final int cost;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.amber[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber[300]!),
      ),
      child: Text(
        '$label: $cost Z',
        style: TextStyle(
          color: Colors.amber[800],
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
