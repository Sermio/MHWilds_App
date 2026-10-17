import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/skill_sprite_icon.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/skills.dart' as skills_model;
import 'package:mhwilds_app/models/weapon.dart';
import 'package:mhwilds_app/providers/skills_provider.dart';
import 'package:mhwilds_app/utils/spacing.dart';
import 'package:provider/provider.dart';

/// Lista de habilidades de una arma con su icono y descripción.
class WeaponSkillsSection extends StatelessWidget {
  final Weapon weapon;

  const WeaponSkillsSection({super.key, required this.weapon});

  static skills_model.SkillIcon? _skillIconForId(
      int skillId, BuildContext context) {
    final skillsProvider = Provider.of<SkillsProvider>(context, listen: false);
    for (final skill in skillsProvider.allSkills) {
      if (skill.id == skillId) {
        return skill.icon;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.flash_on,
              size: 16,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                '${AppLocalizations.of(context)!.skills}:',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface.withValues(alpha: 0.8)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...weapon.skills.map((skill) {
          final icon = _skillIconForId(skill.skill.id, context);
          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border:
                  Border.all(color: colorScheme.primary.withValues(alpha: 0.3)),
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
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${skill.skill.name} +${skill.level}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold),
                        ),
                      ),
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }
}
