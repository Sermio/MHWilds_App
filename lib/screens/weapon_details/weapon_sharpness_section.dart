import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/sharpness_bar.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/weapon.dart';
import 'package:mhwilds_app/screens/weapon_details/section_card.dart';
import 'package:mhwilds_app/utils/game_colors.dart';

/// Indica si la afilada tiene algún segmento con valor.
bool hasSharpnessData(Sharpness s) {
  return s.red > 0 ||
      s.orange > 0 ||
      s.yellow > 0 ||
      s.green > 0 ||
      s.blue > 0 ||
      s.white > 0 ||
      s.purple > 0;
}

/// Barra de afilada con su leyenda de colores.
class WeaponSharpnessSection extends StatelessWidget {
  const WeaponSharpnessSection({super.key, required this.sharpness});

  final Sharpness sharpness;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final game = GameColors.of(context);
    final entries = <(String, Color, int)>[
      (l10n.sharpnessRed, game.sharpnessRed, sharpness.red),
      (l10n.sharpnessOrange, game.sharpnessOrange, sharpness.orange),
      (l10n.sharpnessYellow, game.sharpnessYellow, sharpness.yellow),
      (l10n.sharpnessGreen, game.sharpnessGreen, sharpness.green),
      (l10n.sharpnessBlue, game.sharpnessBlue, sharpness.blue),
      (l10n.sharpnessWhite, game.sharpnessWhite, sharpness.white),
      (l10n.sharpnessPurple, game.sharpnessPurple, sharpness.purple),
    ];

    return WeaponTitledCard(
      icon: Icons.content_cut,
      title: l10n.sharpness,
      child: Column(
        children: [
          SharpnessBar(sharpness: sharpness, height: 40, borderRadius: 20),
          const SizedBox(height: 12),
          MediaQuery.withClampedTextScaling(
            maxScaleFactor: 1.3,
            child: Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                for (final (label, color, value) in entries)
                  if (value > 0)
                    _SharpnessLegendItem(
                      label: label,
                      color: color,
                      value: value,
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SharpnessLegendItem extends StatelessWidget {
  const _SharpnessLegendItem({
    required this.label,
    required this.color,
    required this.value,
  });

  final String label;
  final Color color;
  final int value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // El blanco necesita contorno para ser visible.
    final bool needsOutline = color == GameColors.of(context).sharpnessWhite;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            border: needsOutline
                ? Border.all(color: colorScheme.outlineVariant, width: 2)
                : null,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$label: $value',
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
