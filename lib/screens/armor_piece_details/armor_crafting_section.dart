import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/material_cost_widgets.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/armor_piece.dart' as armor_models;
import 'package:mhwilds_app/screens/armor_piece_details/armor_section_card.dart';

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
            MaterialCostTable(materials: materials),
          if (zennyCost > 0) ...[
            SizedBox(height: materials.isEmpty ? 8 : 20),
            materials.isEmpty
                ? SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: ZennyCostChip(label: l10n.craft, cost: zennyCost),
                    ),
                  )
                : ZennyCostChip(label: l10n.craft, cost: zennyCost),
          ],
        ],
      ),
    );
  }
}
