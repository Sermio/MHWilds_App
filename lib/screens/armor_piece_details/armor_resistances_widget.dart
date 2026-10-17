import 'package:flutter/material.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/armor_piece.dart' as armor_models;
import 'package:mhwilds_app/utils/weapon_utils.dart';

class ArmorResistancesWidget extends StatelessWidget {
  final armor_models.ArmorPiece armor;

  const ArmorResistancesWidget({super.key, required this.armor});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${AppLocalizations.of(context)!.resistances}:',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w600, color: colorScheme.primary),
        ),
        const SizedBox(height: 8),
        Wrap(
          children: [
            for (final entry in armor.resistances.entries)
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(entry.value.toString()),
                    const SizedBox(width: 5),
                    SizedBox(
                      height: 20,
                      child: Image.asset(
                          'assets/imgs/elements/${entry.key.toLowerCase()}.webp',
                          semanticLabel: WeaponUtils.elementLabel(entry.key)),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
