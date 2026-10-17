import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/gear_sprite_icon.dart';
import 'package:mhwilds_app/models/armor_piece.dart' as armor_models;
import 'package:mhwilds_app/utils/spacing.dart';

/// Cabecera con imagen, nombre y descripción de la pieza.
class ArmorHeader extends StatelessWidget {
  final armor_models.ArmorPiece armor;

  const ArmorHeader({super.key, required this.armor});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final kind = armor.kind.toLowerCase();
    final column = armorColumnByKind[kind];
    final fallbackImage = Image.asset(
      'assets/imgs/armor/$kind/rarity${armor.rarity}.webp',
      fit: BoxFit.cover,
      excludeFromSemantics: true,
    );
    return Container(
      margin: const EdgeInsets.all(AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: column != null
                  ? GearSpriteIcon(
                      column: column,
                      rarity: armor.rarity,
                      size: 80,
                      fallback: fallbackImage,
                    )
                  : fallbackImage,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            armor.name,
            style: textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold, color: colorScheme.onSurface),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          if (armor.description.isNotEmpty)
            Text(
              armor.description,
              style: textTheme.bodyLarge!.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.8),
                  height: 1.4),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
