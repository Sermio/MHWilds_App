import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/section_heading.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/monster.dart';
import 'package:mhwilds_app/screens/monster_details/section_card.dart';
import 'package:mhwilds_app/utils/colors.dart';
import 'package:mhwilds_app/utils/spacing.dart';

/// Lista de partes rompibles del monstruo.
class MonsterBreakablePartsSection extends StatelessWidget {
  final List<BreakablePart> parts;

  const MonsterBreakablePartsSection({super.key, required this.parts});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return MonsterSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeading(
              title: AppLocalizations.of(context)!.breakableParts,
              icon: Icons.hardware),
          const SizedBox(height: 16),
          ...parts.map(
            (part) => Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Row(
                children: [
                  Icon(Icons.construction,
                      color: AppColors.goldAccent(context)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      part.name,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
