import 'package:flutter/material.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/weapon.dart';
import 'package:mhwilds_app/screens/weapon_details/crafting_costs.dart';

/// Hoja inferior con los materiales de crafteo de [weapon].
void showWeaponCraftingModal(BuildContext context, Weapon weapon) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _CraftingModalContent(weapon: weapon),
  );
}

class _CraftingModalContent extends StatelessWidget {
  const _CraftingModalContent({required this.weapon});

  final Weapon weapon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(20),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${AppLocalizations.of(context)!.craftingMaterials} - ${weapon.name}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                tooltip: AppLocalizations.of(context)!.close,
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: CraftingCostsBody(
                crafting: weapon.crafting,
                stretch: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
