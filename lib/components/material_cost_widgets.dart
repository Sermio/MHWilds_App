import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/material_image.dart';
import 'package:mhwilds_app/models/armor_piece.dart' as armor_models;
import 'package:mhwilds_app/screens/item_details.dart';
import 'package:mhwilds_app/utils/colors.dart';
import 'package:mhwilds_app/utils/spacing.dart';

/// Tabla de materiales de fabricación/mejora (armas y armaduras): un único
/// contenedor con una fila por material (icono, nombre y cantidad) separadas
/// por líneas finas, como [DropChanceTable]. Cada fila abre el objeto.
class MaterialCostTable extends StatelessWidget {
  const MaterialCostTable({super.key, required this.materials});

  final List<armor_models.Material> materials;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            for (var i = 0; i < materials.length; i++) ...[
              if (i > 0) Divider(height: 1, color: colorScheme.outlineVariant),
              _MaterialRow(material: materials[i]),
            ],
          ],
        ),
      ),
    );
  }
}

class _MaterialRow extends StatelessWidget {
  const _MaterialRow({required this.material});

  final armor_models.Material material;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ItemDetails(item: material.item),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: MaterialImage(item: material.item, width: 40, height: 40),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                material.item.name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              'x${material.quantity}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.goldAccent(context),
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Coste en zenny ("Fabricar: 1200 Z") con los colores dorados del tema.
class ZennyCostChip extends StatelessWidget {
  const ZennyCostChip({super.key, required this.label, required this.cost});

  final String label;
  final int cost;

  @override
  Widget build(BuildContext context) {
    final gold = AppColors.goldAccent(context);
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
      decoration: BoxDecoration(
        color: gold.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: gold.withValues(alpha: 0.4)),
      ),
      child: Text(
        '$label: $cost Z',
        style: TextStyle(color: gold, fontWeight: FontWeight.w600),
      ),
    );
  }
}
