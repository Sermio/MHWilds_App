import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/set_piece_tag.dart';
import 'package:mhwilds_app/components/skill_sprite_icon.dart';
import 'package:mhwilds_app/models/armor_piece.dart' as armor_models;
import 'package:mhwilds_app/models/skills.dart' as skills_model;
import 'package:mhwilds_app/utils/spacing.dart';

/// Tarjeta de una skill de una pieza de armadura (nombre, nivel, descripción).
class ArmorPieceSkillCard extends StatelessWidget {
  final armor_models.SkillInfo skill;
  final skills_model.SkillIcon? icon;

  const ArmorPieceSkillCard({
    super.key,
    required this.skill,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.only(right: AppSpacing.sm),
                child: SkillSpriteIcon(
                  iconId: icon?.id,
                  iconKind: icon?.kind,
                  size: 24,
                  fallback: Icon(
                    Icons.auto_awesome,
                    size: 14,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: Text(
                    '${skill.name ?? skill.skill.name} +${skill.level}',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              if (skill.setPiecesRequired != null)
                Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.sm),
                  child: SetPieceTag(count: skill.setPiecesRequired!),
                ),
            ],
          ),
          if (skill.description.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              skill.description,
              style: TextStyle(
                fontSize: 11,
                color: colorScheme.onSurface.withValues(alpha: 0.8),
                height: 1.3,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
