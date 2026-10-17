import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/material_image.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/armor_piece.dart' as armor_models;
import 'package:mhwilds_app/providers/en_names_cache.dart';
import 'package:mhwilds_app/screens/armor_piece_details/armor_section_card.dart';
import 'package:mhwilds_app/screens/item_details.dart';
import 'package:mhwilds_app/utils/spacing.dart';
import 'package:provider/provider.dart';

/// Materiales de la receta, sin las entradas de Zenny.
List<armor_models.Material> armorRecipeMaterials(
        armor_models.ArmorPiece armor) =>
    armor.crafting.materials
        .where((material) =>
            material.item.name.toLowerCase() != 'zenny' &&
            material.item.name.toLowerCase() != 'zenny cost')
        .toList();

/// Indica si la pieza tiene datos de crafteo que mostrar.
bool armorHasCraftingData(armor_models.ArmorPiece armor) =>
    armorRecipeMaterials(armor).isNotEmpty || armor.crafting.zennyCost > 0;

/// Sección de materiales de crafteo y coste en Zenny.
class ArmorCraftingSection extends StatelessWidget {
  final armor_models.ArmorPiece armor;

  const ArmorCraftingSection({super.key, required this.armor});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final materials = armorRecipeMaterials(armor);
    final zennyCost = armor.crafting.zennyCost;
    return ArmorSectionCard(
      icon: Icons.build,
      title: l10n.craftingMaterials,
      child: Column(
        children: [
          if (materials.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final material in materials)
                  _MaterialItem(material: material),
              ],
            ),
          if (zennyCost > 0) ...[
            SizedBox(height: materials.isEmpty ? 8 : 20),
            materials.isEmpty
                ? SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: _CostChip(label: l10n.craft, cost: zennyCost),
                    ),
                  )
                : _CostChip(label: l10n.craft, cost: zennyCost),
          ],
        ],
      ),
    );
  }
}

class _MaterialItem extends StatelessWidget {
  final armor_models.Material material;

  const _MaterialItem({required this.material});

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
                      materialName: context
                              .watch<EnNamesCache>()
                              .nameForItemImage(
                                  material.item.id, material.item.name) ??
                          material.item.name,
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

class _CostChip extends StatelessWidget {
  final String label;
  final int cost;

  const _CostChip({required this.label, required this.cost});

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
