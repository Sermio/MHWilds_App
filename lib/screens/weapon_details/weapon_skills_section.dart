import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/skill_sprite_icon.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/skills.dart';
import 'package:mhwilds_app/models/weapon.dart';
import 'package:mhwilds_app/screens/weapon_details/section_card.dart';
import 'package:mhwilds_app/utils/colors.dart';
import 'package:mhwilds_app/utils/spacing.dart';

/// Habilidades del arma con todos sus rangos; resalta los que da el arma.
class WeaponSkillsSection extends StatelessWidget {
  const WeaponSkillsSection({
    super.key,
    required this.skills,
    required this.weaponSkills,
  });

  final Future<List<Skills>> skills;
  final List<WeaponSkill> weaponSkills;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final bodyLarge = Theme.of(context).textTheme.bodyLarge!;

    Widget message(String text) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              text,
              style: bodyLarge.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.8)),
            ),
          ),
        );

    return WeaponTitledCard(
      icon: Icons.flash_on,
      title: l10n.skills,
      child: FutureBuilder<List<Skills>>(
        future: skills,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: CircularProgressIndicator(color: colorScheme.primary),
              ),
            );
          } else if (snapshot.hasError) {
            return message(l10n.errorLoadingSkills);
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return message(l10n.noSkillsAvailable);
          }
          return Column(
            children: snapshot.data!
                .map((skillInfo) => _SkillCard(
                      skillInfo: skillInfo,
                      weaponSkills: weaponSkills,
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  const _SkillCard({required this.skillInfo, required this.weaponSkills});

  final Skills skillInfo;
  final List<WeaponSkill> weaponSkills;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: colorScheme.surface,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SkillSpriteIcon(
                    iconId: skillInfo.icon?.id,
                    iconKind: skillInfo.icon?.kind,
                    size: 40,
                    fallback: Icon(
                      Icons.auto_awesome,
                      size: 22,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      skillInfo.name,
                      style: textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface),
                    ),
                    if (skillInfo.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        skillInfo.description,
                        style: textTheme.bodyMedium!.copyWith(
                            color:
                                colorScheme.onSurface.withValues(alpha: 0.8)),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...skillInfo.ranks.map((rank) {
            final bool isCurrentLevel = weaponSkills.any(
              (armorSkill) =>
                  armorSkill.skill.id == skillInfo.id &&
                  armorSkill.level == rank.level,
            );
            return _SkillRankRow(
              level: rank.level,
              description: rank.description,
              isCurrentLevel: isCurrentLevel,
            );
          }),
        ],
      ),
    );
  }
}

class _SkillRankRow extends StatelessWidget {
  const _SkillRankRow({
    required this.level,
    required this.description,
    required this.isCurrentLevel,
  });

  final int level;
  final String description;
  final bool isCurrentLevel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isCurrentLevel
            ? AppColors.goldSoft.withValues(alpha: 0.1)
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCurrentLevel
              ? AppColors.goldSoft.withValues(alpha: 0.3)
              : colorScheme.outlineVariant,
          width: isCurrentLevel ? 2 : 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: isCurrentLevel
                  ? AppColors.goldSoft
                  : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${AppLocalizations.of(context)!.lv} $level',
              style: textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isCurrentLevel
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              description,
              style: textTheme.bodyMedium!.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight:
                      isCurrentLevel ? FontWeight.w500 : FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }
}
