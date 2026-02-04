part of '../weapons_list.dart';

extension WeaponsListSlotsAndSharpness on _WeaponsListState {
  Widget _buildWeaponSlots(Weapon weapon) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.settings,
              size: 16,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 6),
            Text(
              'Slots:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildSlotsWidget(weapon.slots),
      ],
    );
  }

  Widget _buildSlotsWidget(List<int> slots) {
    final colorScheme = Theme.of(context).colorScheme;
    if (slots.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Text(
          'No slots',
          style: TextStyle(
            fontSize: 11,
            color: colorScheme.onSurface.withOpacity(0.8),
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: slots.map((slot) {
        Color slotColor;
        switch (slot) {
          case 1:
            slotColor = Colors.green;
            break;
          case 2:
            slotColor = Colors.blue;
            break;
          case 3:
            slotColor = Colors.purple;
            break;
          case 4:
            slotColor = Colors.orange;
            break;
          default:
            slotColor = Colors.grey;
        }

        return Container(
          margin: const EdgeInsets.only(right: 6),
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: slotColor.withOpacity(0.2),
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
        );
      }).toList(),
    );
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
            Icon(
              Icons.content_cut,
              color: colorScheme.primary,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              'Sharpness',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withOpacity(0.8),
              ),
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
