import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/decoration_sprite_icon.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/armor_piece.dart' as armor_models;
import 'package:mhwilds_app/utils/spacing.dart';

class ArmorPieceSlotsWidget extends StatelessWidget {
  final armor_models.ArmorPiece armorPiece;

  const ArmorPieceSlotsWidget({super.key, required this.armorPiece});

  @override
  Widget build(BuildContext context) {
    if (armorPiece.slots.isEmpty) {
      return Text(
        AppLocalizations.of(context)!.noSlots,
        style: const TextStyle(
          color: Colors.grey,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: armorPiece.slots.map((slot) {
        final Color slotColor = _slotColor(slot);
        return Padding(
          padding: const EdgeInsets.only(left: AppSpacing.xs),
          child: DecorationSpriteIcon(
            slot: slot,
            size: 20,
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
                    fontSize: 10,
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

  static Color _slotColor(int slot) {
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
}
