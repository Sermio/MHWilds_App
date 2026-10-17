import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/set_piece_tag.dart';
import 'package:mhwilds_app/components/skill_sprite_icon.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/armor_piece.dart' as armor_models;
import 'package:mhwilds_app/models/skills.dart';
import 'package:mhwilds_app/screens/armor_piece_details/armor_section_card.dart';
import 'package:mhwilds_app/utils/spacing.dart';

/// Sección de habilidades de la pieza; carga los datos desde [skills].
class ArmorSkillsSection extends StatelessWidget {
  final armor_models.ArmorPiece armor;
  final Future<List<Skills>> skills;

  const ArmorSkillsSection(
      {super.key, required this.armor, required this.skills});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return ArmorSectionCard(
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
            return _Message(text: l10n.errorLoadingSkills);
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _Message(text: l10n.noSkillsAvailable);
          }
          return Column(
            children: [
              for (final skillInfo in snapshot.data!)
                _SkillCard(armor: armor, skillInfo: skillInfo),
            ],
          );
        },
      ),
    );
  }
}

class _Message extends StatelessWidget {
  final String text;

  const _Message({required this.text});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: colorScheme.onSurface.withValues(alpha: 0.8)),
        ),
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  final armor_models.ArmorPiece armor;
  final Skills skillInfo;

  const _SkillCard({required this.armor, required this.skillInfo});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final nameOverride = armor.skills
        .any((as) => as.skill.id == skillInfo.id && as.name != null);
    final hasSetTag = armor.skills.any((as) =>
        as.skill.id == skillInfo.id &&
        (as.setPiecesRequired != null || as.isSetOrGroupBonus));
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
              SizedBox(
                width: 40,
                height: 40,
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
                      nameOverride
                          ? armor.skills
                              .firstWhere((as) =>
                                  as.skill.id == skillInfo.id &&
                                  as.name != null)
                              .name!
                          : skillInfo.name,
                      style: textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface),
                    ),
                    if (skillInfo.description.isNotEmpty &&
                        skillInfo.description !=
                            'No description available') ...[
                      const SizedBox(height: 4),
                      Text(
                        skillInfo.description,
                        style: textTheme.bodyMedium!.copyWith(
                            color:
                                colorScheme.onSurface.withValues(alpha: 0.8)),
                      ),
                    ],
                    if (hasSetTag)
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.sm),
                        child: SetPieceTag(
                          count: armor.skills
                              .firstWhere((as) =>
                                  as.skill.id == skillInfo.id &&
                                  as.setPiecesRequired != null)
                              .setPiecesRequired!,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final rank in skillInfo.ranks)
            _RankRow(
              level: rank.level,
              description: rank.description,
              isCurrentLevel: armor.skills.any((armorSkill) =>
                  armorSkill.skill.id == skillInfo.id &&
                  armorSkill.level == rank.level),
            ),
        ],
      ),
    );
  }
}

class _RankRow extends StatelessWidget {
  final int level;
  final String description;
  final bool isCurrentLevel;

  const _RankRow({
    required this.level,
    required this.description,
    required this.isCurrentLevel,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isCurrentLevel
            ? colorScheme.primary.withValues(alpha: 0.1)
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCurrentLevel
              ? colorScheme.primary.withValues(alpha: 0.3)
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
                  ? colorScheme.primary
                  : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppRadius.lg),
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
