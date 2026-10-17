import 'package:flutter/material.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/utils/game_colors.dart';
import 'package:mhwilds_app/utils/spacing.dart';

class RarityChip extends StatelessWidget {
  final int rarity;
  final double fontSize;
  final EdgeInsets padding;

  const RarityChip({
    super.key,
    required this.rarity,
    this.fontSize = 12,
    this.padding = const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
  });

  @override
  Widget build(BuildContext context) {
    final color = GameColors.of(context).rarity(rarity);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        AppLocalizations.of(context)!.rarityLevel(rarity),
        style: TextStyle(
          fontSize: fontSize,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
