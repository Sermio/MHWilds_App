import 'package:flutter/material.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/utils/colors.dart';
import 'package:mhwilds_app/utils/spacing.dart';

/// "carve-rotten" -> "Carve Rotten". Solo para tipos que la API añada y que
/// aún no tengan traducción en [rewardKindLabel].
String formatRewardKind(String kind) => kind
    .replaceAll('-', ' ')
    .split(' ')
    .where((w) => w.isNotEmpty)
    .map((w) => w[0].toUpperCase() + w.substring(1))
    .join(' ');

/// Tipo de condición de drop traducido. Los tipos desconocidos caen en
/// [formatRewardKind]; hay que añadirlos aquí y en los ARB cuando aparezcan.
String rewardKindLabel(AppLocalizations l10n, String kind) => switch (kind) {
      'target-reward' => l10n.rewardTargetReward,
      'carve' => l10n.rewardCarve,
      'broken-part' => l10n.rewardBrokenPart,
      'carve-rotten' => l10n.rewardCarveRotten,
      'wound-destroyed' => l10n.rewardWoundDestroyed,
      'tempered-wound-destroyed' => l10n.rewardTemperedWoundDestroyed,
      'carve-severed' => l10n.rewardCarveSevered,
      'carve-rotten-severed' => l10n.rewardCarveRottenSevered,
      'carve-crystallized' => l10n.rewardCarveCrystallized,
      'broken-fragment' => l10n.rewardBrokenFragment,
      _ => formatRewardKind(kind),
    };

typedef DropChance = ({int chance, String kind});

/// Tabla de condiciones de drop: un único contenedor con una fila por
/// condición (porcentaje, tipo y barra proporcional) separadas por líneas
/// finas.
class DropChanceTable extends StatelessWidget {
  const DropChanceTable({super.key, required this.rows});

  final List<DropChance> rows;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) Divider(height: 1, color: colorScheme.outlineVariant),
            DropChanceRow(chance: rows[i].chance, kind: rows[i].kind),
          ],
        ],
      ),
    );
  }
}

/// Fila de una condición de drop. Los tipos "tempered" y "arch-tempered" se
/// tiñen (morado / naranja) para distinguirlos.
class DropChanceRow extends StatelessWidget {
  const DropChanceRow({super.key, required this.chance, required this.kind});

  final int chance;
  final String kind;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final lower = kind.toLowerCase();
    final Color? tint = lower.contains('arch-tempered')
        ? Colors.orange[700]
        : lower.contains('tempered')
            ? Colors.purple[700]
            : null;

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.md),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: Text(
              '$chance%',
              textAlign: TextAlign.end,
              style: textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: tint ?? AppColors.goldAccent(context),
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rewardKindLabel(AppLocalizations.of(context)!, kind),
                  style: textTheme.bodyMedium!.copyWith(
                      color: tint ?? colorScheme.onSurface,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (chance / 100).clamp(0.0, 1.0),
                    minHeight: 8,
                    color: tint ?? AppColors.goldSoft,
                    backgroundColor:
                        colorScheme.outlineVariant.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
