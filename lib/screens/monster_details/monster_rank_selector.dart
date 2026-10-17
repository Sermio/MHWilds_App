import 'package:flutter/material.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/utils/spacing.dart';

/// Selector de rango (low/high) para las recompensas.
class MonsterRankSelector extends StatelessWidget {
  final String selectedRank;
  final bool isLowRankAvailable;
  final bool isHighRankAvailable;

  /// 0 = low, 1 = high. Solo se invoca para rangos disponibles.
  final ValueChanged<int> onRankChanged;

  const MonsterRankSelector({
    super.key,
    required this.selectedRank,
    required this.isLowRankAvailable,
    required this.isHighRankAvailable,
    required this.onRankChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: ToggleButtons(
          fillColor: colorScheme.primary,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          disabledColor: colorScheme.onSurface.withValues(alpha: 0.5),
          isSelected: [
            selectedRank == 'low' && isLowRankAvailable,
            selectedRank == 'high' && isHighRankAvailable,
          ],
          onPressed: (index) {
            if ((index == 0 && isLowRankAvailable) ||
                (index == 1 && isHighRankAvailable)) {
              onRankChanged(index);
            }
          },
          children: [
            _label(colorScheme, l10n.lowRank, 'low', isLowRankAvailable),
            _label(colorScheme, l10n.highRank, 'high', isHighRankAvailable),
          ],
        ),
      ),
    );
  }

  Widget _label(
      ColorScheme colorScheme, String text, String rank, bool available) {
    final selected = selectedRank == rank;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        text,
        style: TextStyle(
          color: !available
              ? colorScheme.onSurface.withValues(alpha: 0.5)
              : (selected
                  ? colorScheme.onPrimary
                  : colorScheme.onSurface.withValues(alpha: 0.9)),
          fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
        ),
      ),
    );
  }
}
