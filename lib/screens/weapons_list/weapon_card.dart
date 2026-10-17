import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/gear_sprite_icon.dart';
import 'package:mhwilds_app/components/rarity_chip.dart';
import 'package:mhwilds_app/models/weapon.dart';
import 'package:mhwilds_app/screens/weapon_details.dart';
import 'package:mhwilds_app/screens/weapons_list/weapon_kind_helpers.dart';
import 'package:mhwilds_app/screens/weapons_list/weapon_skills.dart';
import 'package:mhwilds_app/screens/weapons_list/weapon_slots.dart';
import 'package:mhwilds_app/screens/weapons_list/weapon_stats.dart';
import 'package:mhwilds_app/utils/game_colors.dart';
import 'package:mhwilds_app/utils/spacing.dart';

/// Tarjeta de arma de la vista de lista.
class WeaponCard extends StatelessWidget {
  final Weapon weapon;

  const WeaponCard({super.key, required this.weapon});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WeaponDetails(weapon: weapon),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WeaponCardHeader(weapon: weapon),
                const SizedBox(height: 16),
                WeaponStats(weapon: weapon),
                if (weapon.slots.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  WeaponSlotsRow(slots: weapon.slots),
                ],
                if (weaponHasSharpnessData(weapon)) ...[
                  const SizedBox(height: 16),
                  WeaponSharpnessSection(weapon: weapon),
                ],
                if (weapon.skills.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  WeaponSkillsSection(weapon: weapon),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Cabecera de la tarjeta: icono, nombre y rareza.
class WeaponCardHeader extends StatelessWidget {
  final Weapon weapon;

  const WeaponCardHeader({super.key, required this.weapon});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final int? spriteColumn = weaponColumnByKind[weapon.kind];
    final fallbackIcon = Icon(
      weaponKindIcon(weapon.kind),
      color: GameColors.of(context).kind(weapon.kind),
      size: 42,
    );

    return Row(
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: Center(
            child: spriteColumn != null
                ? GearSpriteIcon(
                    column: spriteColumn,
                    rarity: weapon.rarity,
                    size: 42,
                    fallback: fallbackIcon,
                  )
                : fallbackIcon,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                weapon.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              RarityChip(rarity: weapon.rarity),
            ],
          ),
        ),
        Icon(Icons.arrow_forward_ios,
            color: colorScheme.onSurfaceVariant, size: 20),
      ],
    );
  }
}
