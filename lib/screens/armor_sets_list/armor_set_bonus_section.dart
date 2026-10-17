import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/skill_sprite_icon.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/armor_set.dart' as set_models;
import 'package:mhwilds_app/models/skills.dart' as skills_model;
import 'package:mhwilds_app/utils/spacing.dart';

class ArmorSetBonusSection extends StatefulWidget {
  final set_models.ArmorSet armorSet;
  final skills_model.SkillIcon? Function(int) onSkillIconRequest;

  const ArmorSetBonusSection({
    super.key,
    required this.armorSet,
    required this.onSkillIconRequest,
  });

  @override
  State<ArmorSetBonusSection> createState() => _ArmorSetBonusSectionState();
}

class _ArmorSetBonusSectionState extends State<ArmorSetBonusSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Título del bono para comparar
    final String bonusTitleName = widget.armorSet.setBonusSkill.name.isNotEmpty
        ? widget.armorSet.setBonusSkill.name
        : (widget.armorSet.groupBonusSkill.name.isNotEmpty
            ? widget.armorSet.groupBonusSkill.name
            : widget.armorSet.groupBonusSkill.skill.name);

    // Agrupar habilidades
    final Map<int, Map<String, dynamic>> bonusSkills = {};
    for (var piece in widget.armorSet.pieces) {
      for (var skillInfo in piece.skills) {
        if (skillInfo.isSetOrGroupBonus) {
          // Priorizar descripción de la habilidad si no es la genérica
          String bestDescription = skillInfo.skill.description;
          if (bestDescription == 'No description available' ||
              bestDescription.isEmpty) {
            bestDescription = skillInfo.description;
          }

          bonusSkills[skillInfo.skill.id] = {
            'skill': skillInfo.skill,
            'description': bestDescription,
          };
        }
      }
    }

    final allSkills = bonusSkills.values.toList();
    if (allSkills.isEmpty) return const SizedBox.shrink();

    // Identificar el bono primario:
    // 1. Intentar coincidir por nombre Y que sea tipo 'set'
    int primaryIndex = allSkills.indexWhere((s) {
      final skill = s['skill'] as skills_model.Skills;
      return skill.name.toLowerCase() == bonusTitleName.toLowerCase() &&
          skill.kind.toLowerCase() == 'set';
    });

    // 2. Si no, intentar coincidir solo por nombre
    if (primaryIndex == -1) {
      primaryIndex = allSkills.indexWhere((s) {
        final skill = s['skill'] as skills_model.Skills;
        return skill.name.toLowerCase() == bonusTitleName.toLowerCase();
      });
    }

    // 3. Si no, buscar la primera que sea de tipo 'set'
    if (primaryIndex == -1) {
      primaryIndex = allSkills.indexWhere((s) {
        final skill = s['skill'] as skills_model.Skills;
        return skill.kind.toLowerCase() == 'set';
      });
    }

    // 4. Si aún no hay nada, usar la primera disponible
    if (primaryIndex == -1) primaryIndex = 0;

    final primarySkill = allSkills[primaryIndex];
    final List<Map<String, dynamic>> extraSkills = [];
    for (int i = 0; i < allSkills.length; i++) {
      if (i != primaryIndex) {
        extraSkills.add(allSkills[i]);
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.group_work,
                size: 20,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${AppLocalizations.of(context)!.setBonus} ${(primarySkill['skill'] as skills_model.Skills).name}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Bono primario (siempre visible)
          _buildSkillCard(
              context, primarySkill['skill'], primarySkill['description']),

          // Otros bonos (colapsables)
          if (extraSkills.isNotEmpty) ...[
            if (_isExpanded)
              ...extraSkills.map((s) =>
                  _buildSkillCard(context, s['skill'], s['description'])),

            // Botón de expansión centrando
            Center(
              child: TextButton.icon(
                onPressed: () => setState(() => _isExpanded = !_isExpanded),
                icon: Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  size: 18,
                ),
                label: Text(
                  _isExpanded
                      ? AppLocalizations.of(context)!.showLess
                      : '${AppLocalizations.of(context)!.showMore} (${extraSkills.length})',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSkillCard(
      BuildContext context, skills_model.Skills skill, String description) {
    return _BonusSkillCard(
      skill: skill,
      description: description,
      icon: widget.onSkillIconRequest(skill.id),
    );
  }
}

class _BonusSkillCard extends StatelessWidget {
  final skills_model.Skills skill;
  final String description;
  final skills_model.SkillIcon? icon;

  const _BonusSkillCard({
    required this.skill,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
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
                    color: const Color(0xFFC5A35C)
                        .withValues(alpha: 0.8), // Dorado/Beige solicitado
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: Text(
                    skill.name,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          if (description.isNotEmpty &&
              description != 'No description available') ...[
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.8),
                  height: 1.3),
            ),
          ],
        ],
      ),
    );
  }
}
