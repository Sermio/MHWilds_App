import 'package:flutter/material.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/weapon.dart';

/// Tipos de arma en el orden en que se muestran en los filtros.
const List<String> weaponKinds = [
  'great-sword',
  'long-sword',
  'sword-shield',
  'dual-blades',
  'hammer',
  'hunting-horn',
  'lance',
  'gunlance',
  'switch-axe',
  'charge-blade',
  'insect-glaive',
  'bow',
  'light-bowgun',
  'heavy-bowgun',
];

String weaponKindLabel(BuildContext context, String kind) {
  final l10n = AppLocalizations.of(context)!;
  switch (kind) {
    case 'great-sword':
      return l10n.weaponKindGreatSword;
    case 'long-sword':
      return l10n.weaponKindLongSword;
    case 'sword-shield':
      return l10n.weaponKindSwordShield;
    case 'dual-blades':
      return l10n.weaponKindDualBlades;
    case 'hammer':
      return l10n.weaponKindHammer;
    case 'hunting-horn':
      return l10n.weaponKindHuntingHorn;
    case 'lance':
      return l10n.weaponKindLance;
    case 'gunlance':
      return l10n.weaponKindGunlance;
    case 'switch-axe':
      return l10n.weaponKindSwitchAxe;
    case 'charge-blade':
      return l10n.weaponKindChargeBlade;
    case 'insect-glaive':
      return l10n.weaponKindInsectGlaive;
    case 'bow':
      return l10n.weaponKindBow;
    case 'light-bowgun':
      return l10n.weaponKindLightBowgun;
    case 'heavy-bowgun':
      return l10n.weaponKindHeavyBowgun;
    default:
      return kind;
  }
}

IconData weaponKindIcon(String kind) {
  switch (kind) {
    case 'sword-shield':
      return Icons.shield;
    case 'hammer':
      return Icons.build;
    case 'hunting-horn':
      return Icons.music_note;
    case 'bow':
      return Icons.arrow_upward;
    default:
      return Icons.gps_fixed;
  }
}

/// Indica si el arma tiene algún tramo de afilado.
bool weaponHasSharpnessData(Weapon weapon) {
  final s = weapon.sharpness;
  return s.red > 0 ||
      s.orange > 0 ||
      s.yellow > 0 ||
      s.green > 0 ||
      s.blue > 0 ||
      s.white > 0 ||
      s.purple > 0;
}

/// Indica si el arma tiene daño elemental o de estado.
bool weaponHasElementalDamage(Weapon weapon) {
  if (weapon.specials is List) {
    final specials = weapon.specials as List;
    return specials.any((special) {
      if (special is Map<String, dynamic>) {
        return (special['kind'] == 'element' || special['kind'] == 'status') &&
            ((special['damage'] as Map<String, dynamic>?)?['raw'] as num? ??
                    0) >
                0;
      }
      return false;
    });
  }
  return false;
}
