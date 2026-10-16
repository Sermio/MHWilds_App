part of '../weapons_list.dart';

extension _WeaponsListSlotsAndSharpness on _WeaponsListState {
  Widget _buildWeaponSlots(Weapon weapon) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Text(
          '${AppLocalizations.of(context)!.slots}:',
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withValues(alpha: 0.8)),
        ),
        const SizedBox(width: 8),
        const Spacer(),
        _buildSlotsWidget(weapon.slots),
      ],
    );
  }

  Widget _buildSlotsWidget(List<int> slots) {
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
        final Color slotColor = _slotColor(slot);
        return Padding(
          padding: const EdgeInsets.only(left: 6),
          child: DecorationSpriteIcon(
            slot: slot,
            size: 18,
            fallback: Container(
              decoration: BoxDecoration(
                color: slotColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: slotColor, width: 1),
              ),
              child: Center(
                child: Text(
                  slot.toString(),
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: slotColor,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _slotColor(int slot) {
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

  // Método auxiliar para verificar si el weapon tiene datos de sharpness
  bool _hasSharpnessData(Weapon weapon) {
    return weapon.sharpness.red > 0 ||
        weapon.sharpness.orange > 0 ||
        weapon.sharpness.yellow > 0 ||
        weapon.sharpness.green > 0 ||
        weapon.sharpness.blue > 0 ||
        weapon.sharpness.white > 0 ||
        weapon.sharpness.purple > 0;
  }

  // Método para construir la sección de sharpness
  Widget _buildSharpnessSection(Weapon weapon) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              AppLocalizations.of(context)!.sharpness,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withValues(alpha: 0.8)),
            ),
          ],
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
