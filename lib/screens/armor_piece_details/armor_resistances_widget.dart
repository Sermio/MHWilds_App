import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/element_icon.dart';
import 'package:mhwilds_app/components/stat_row.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/armor_piece.dart' as armor_models;

class ArmorResistancesWidget extends StatelessWidget {
  final armor_models.ArmorPiece armor;

  const ArmorResistancesWidget({super.key, required this.armor});

  @override
  Widget build(BuildContext context) {
    return StatRow(
      title: AppLocalizations.of(context)!.resistances,
      value: Wrap(
        spacing: 10,
        runSpacing: 4,
        children: [
          for (final entry in armor.resistances.entries)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(entry.value.toString()),
                const SizedBox(width: 5),
                ElementIcon(entry.key, size: 20),
              ],
            ),
        ],
      ),
    );
  }
}
