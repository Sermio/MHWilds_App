import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/section_heading.dart';
import 'package:mhwilds_app/components/element_icon.dart';
import 'package:mhwilds_app/components/label_value_row.dart';
import 'package:mhwilds_app/components/monster_details_card.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/monster.dart';
import 'package:mhwilds_app/screens/monster_details/section_card.dart';
import 'package:mhwilds_app/utils/spacing.dart';

/// Debilidades y resistencias elementales / de estado.
class MonsterWeaknessesSection extends StatelessWidget {
  final List<Weakness> weaknesses;
  final List<Resistance> resistances;

  const MonsterWeaknessesSection({
    super.key,
    required this.weaknesses,
    required this.resistances,
  });

  @override
  Widget build(BuildContext context) {
    return MonsterSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabelValueRow(
            label: SectionHeading(
                title: AppLocalizations.of(context)!.weaknessesAndResistances,
                icon: Icons.bolt),
            value: const ElementsInfo(),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _WeaknessesColumn(weaknesses: weaknesses)),
              if (resistances.isNotEmpty) ...[
                const SizedBox(width: 16),
                Expanded(child: _ResistancesColumn(resistances: resistances)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  final String text;

  const _EmptyHint(this.text);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
            fontStyle: FontStyle.italic),
      ),
    );
  }
}

class _WeaknessesColumn extends StatelessWidget {
  final List<Weakness> weaknesses;

  const _WeaknessesColumn({required this.weaknesses});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final validWeaknesses = weaknesses
        .where((w) =>
            w.level >= 1 &&
            ((w.kind == 'element' &&
                    w.element != null &&
                    w.element!.isNotEmpty) ||
                (w.kind == 'status' &&
                    w.status != null &&
                    w.status!.isNotEmpty)))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.weaknesses,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontWeight: FontWeight.bold, color: Colors.red),
        ),
        const SizedBox(height: 8),
        if (validWeaknesses.isEmpty)
          _EmptyHint(l10n.noKnownWeaknesses)
        else
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: validWeaknesses.map((w) {
              final name = (w.kind == 'element' ? w.element : w.status) ?? '';
              if (name.isEmpty) return const SizedBox.shrink();

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElementIcon(
                    name,
                    fallback: Icon(
                      Icons.help_outline,
                      size: 25,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      (4 - w.level).clamp(1, 3),
                      (index) => const Icon(
                        Icons.star,
                        size: 10,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
      ],
    );
  }
}

class _ResistancesColumn extends StatelessWidget {
  final List<Resistance> resistances;

  const _ResistancesColumn({required this.resistances});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Solo resistencias elementales con elemento válido
    final validResistances = resistances
        .where((r) => r.kind == 'element' && r.element.isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.resistances,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        const SizedBox(height: 8),
        if (validResistances.isEmpty)
          _EmptyHint(l10n.noKnownResistances)
        else
          Row(
            children: [
              ...validResistances.map((r) => Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: ElementIcon(r.element),
                  )),
            ],
          ),
      ],
    );
  }
}
