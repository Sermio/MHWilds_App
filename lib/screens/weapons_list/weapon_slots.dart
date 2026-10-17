import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/decoration_sprite_icon.dart';
import 'package:mhwilds_app/components/label_value_row.dart';
import 'package:mhwilds_app/components/sharpness_bar.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/weapon.dart';
import 'package:mhwilds_app/utils/spacing.dart';

/// Fila "Slots: ..." de la tarjeta de arma.
class WeaponSlotsRow extends StatelessWidget {
  final List<int> slots;

  const WeaponSlotsRow({super.key, required this.slots});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return LabelValueRow(
      label: Text(
        '${AppLocalizations.of(context)!.slots}:',
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withValues(alpha: 0.8)),
      ),
      value: WeaponSlotsIcons(slots: slots),
    );
  }
}

/// Iconos de las ranuras de decoración (o texto "sin ranuras").
class WeaponSlotsIcons extends StatelessWidget {
  final List<int> slots;

  const WeaponSlotsIcons({super.key, required this.slots});

  static Color slotColor(int slot) {
    switch (slot) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.purple;
      case 4:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (slots.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Text(
          AppLocalizations.of(context)!.noSlots,
          style: TextStyle(
            fontSize: 11,
            color: colorScheme.onSurface.withValues(alpha: 0.8),
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: slots.map((slot) {
        final Color color = slotColor(slot);
        return Padding(
          padding: const EdgeInsets.only(left: 6),
          child: DecorationSpriteIcon(
            slot: slot,
            size: 18,
            fallback: Container(
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: color, width: 1),
              ),
              child: Center(
                child: Text(
                  slot.toString(),
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Sección "Afilado" con la barra de nitidez.
class WeaponSharpnessSection extends StatelessWidget {
  final Weapon weapon;

  const WeaponSharpnessSection({super.key, required this.weapon});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.sharpness,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withValues(alpha: 0.8)),
        ),
        const SizedBox(height: 8),
        SharpnessBar(
          sharpness: weapon.sharpness,
          height: 16,
          borderRadius: 8,
        ),
      ],
    );
  }
}
