import 'package:flutter/material.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/monster.dart';
import 'package:mhwilds_app/screens/monster_details/section_card.dart';
import 'package:mhwilds_app/utils/spacing.dart';

/// Información básica: tipo, especie, descripción, consejos y variantes.
class MonsterInfoSection extends StatelessWidget {
  final Monster monster;

  const MonsterInfoSection({super.key, required this.monster});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return MonsterSectionCard(
      shadowColor: colorScheme.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MonsterSectionTitle(l10n.monsterInformation,
              tint: colorScheme.primary),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: MonsterInfoRow(l10n.type, monster.displayKind(l10n)),
              ),
              Expanded(
                child:
                    MonsterInfoRow(l10n.species, monster.displaySpecies(l10n)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (monster.description.isNotEmpty) ...[
            MonsterInfoRow(l10n.description, monster.description,
                isDescription: true),
            const SizedBox(height: 12),
          ],
          if (monster.features.isNotEmpty) ...[
            MonsterInfoRow(l10n.features, monster.features,
                isDescription: true),
            const SizedBox(height: 12),
          ],
          if (monster.tips.isNotEmpty) ...[
            MonsterInfoRow(l10n.huntingTips, monster.tips, isDescription: true),
            const SizedBox(height: 12),
          ],
          if (monster.variants.isNotEmpty)
            _VariantsBox(variants: monster.variants),
        ],
      ),
    );
  }
}

class _VariantsBox extends StatelessWidget {
  final List<MonsterVariant> variants;

  const _VariantsBox({required this.variants});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.warning_amber, size: 20, color: Colors.orange[700]),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                AppLocalizations.of(context)!.monsterVariants,
                style: textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.orange[700]),
              ),
            ),
          ]),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: variants.map((v) => _VariantChip(variant: v)).toList(),
          ),
        ],
      ),
    );
  }
}

class _VariantChip extends StatelessWidget {
  final MonsterVariant variant;

  const _VariantChip({required this.variant});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // Determinar si es tempered o arch-tempered
    final bool isTempered = variant.kind.toLowerCase().contains('tempered') ||
        variant.name.toLowerCase().contains('tempered');
    final bool isArchTempered =
        variant.kind.toLowerCase().contains('arch-tempered') ||
            variant.name.toLowerCase().contains('arch-tempered');

    final MaterialColor base = isArchTempered
        ? Colors.orange
        : (isTempered ? Colors.purple : Colors.blue);
    final Color variantColor = base[700]!;

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: base.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: base.withValues(alpha: 0.6), width: 2),
      ),
      child: Column(
        children: [
          Text(
            variant.name,
            style: textTheme.bodyMedium!
                .copyWith(fontWeight: FontWeight.bold, color: variantColor),
          ),
          const SizedBox(height: 4),
          Text(
            variant.kind,
            style: textTheme.bodySmall!
                .copyWith(color: variantColor, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
