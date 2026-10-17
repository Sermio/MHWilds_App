import 'package:flutter/material.dart';

class WeaponUtils {
  // Función para iconos de tipo de arma
  static IconData getWeaponIcon(String kind) {
    switch (kind) {
      case 'great-sword':
        return Icons.gps_fixed;
      case 'long-sword':
        return Icons.gps_fixed;
      case 'sword-shield':
        return Icons.shield;
      case 'dual-blades':
        return Icons.gps_fixed;
      case 'hammer':
        return Icons.build;
      case 'hunting-horn':
        return Icons.music_note;
      case 'lance':
        return Icons.gps_fixed;
      case 'gunlance':
        return Icons.gps_fixed;
      case 'switch-axe':
        return Icons.gps_fixed;
      case 'charge-blade':
        return Icons.gps_fixed;
      case 'insect-glaive':
        return Icons.gps_fixed;
      case 'bow':
        return Icons.arrow_upward;
      case 'light-bowgun':
        return Icons.gps_fixed;
      case 'heavy-bowgun':
        return Icons.gps_fixed;
      default:
        return Icons.gps_fixed;
    }
  }

  // Función para formatear el tipo de arma
  static String formatWeaponKind(String kind) {
    return kind
        .split('-')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
