import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/asset_thumb.dart';
import 'package:mhwilds_app/components/gear_sprite_icon.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/armor_piece.dart' as armor_models;
import 'package:mhwilds_app/models/skills.dart' as skills_model;
import 'package:mhwilds_app/screens/armor_piece_details.dart';
import 'package:mhwilds_app/screens/armor_sets_list/armor_piece_stats.dart';
import 'package:mhwilds_app/utils/game_colors.dart';
import 'package:mhwilds_app/utils/spacing.dart';

/// Tarjeta de una pieza de armadura dentro de un set: cabecera + stats.
class ArmorPieceCard extends StatelessWidget {
  final armor_models.ArmorPiece piece;
  final skills_model.SkillIcon? Function(int) onSkillIconRequest;

  const ArmorPieceCard({
    super.key,
    required this.piece,
    required this.onSkillIconRequest,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArmorDetails(armor: piece),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ArmorPieceHeader(piece: piece),
                const SizedBox(height: 16),
                if (piece.displaySkills.isNotEmpty)
                  ArmorPieceStats(
                    piece: piece,
                    onSkillIconRequest: onSkillIconRequest,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ArmorPieceHeader extends StatelessWidget {
  final armor_models.ArmorPiece piece;

  const _ArmorPieceHeader({required this.piece});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final rarityColor = GameColors.of(context).rarity(piece.rarity);
    final spriteColumn = armorColumnByKind[piece.kind];
    final imagePath =
        'assets/imgs/armor/${piece.kind}/rarity${piece.rarity}.webp';

    return Row(
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: Center(
            child: spriteColumn != null
                ? GearSpriteIcon(
                    column: spriteColumn,
                    rarity: piece.rarity,
                    size: 42,
                    fallback: AssetThumb(imagePath, fit: BoxFit.contain),
                  )
                : AssetThumb(imagePath, fit: BoxFit.contain),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                piece.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: rarityColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: rarityColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  AppLocalizations.of(context)!.rarityLevel(piece.rarity),
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: rarityColor, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.arrow_forward_ios,
          color: colorScheme.onSurfaceVariant,
          size: 20,
        ),
      ],
    );
  }
}
