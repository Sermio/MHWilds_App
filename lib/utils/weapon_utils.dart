import 'package:flutter/material.dart';

class WeaponUtils {

  // Funciones para iconos de elementos
  static IconData getElementIcon(String element) {
    switch (element.toLowerCase()) {
      case 'fire':
        return Icons.local_fire_department;
      case 'water':
        return Icons.water_drop;
      case 'thunder':
        return Icons.flash_on;
      case 'ice':
        return Icons.ac_unit;
      case 'dragon':
        return Icons.auto_awesome;
      case 'poison':
        return Icons.warning;
      case 'paralysis':
        return Icons.electric_bolt;
      case 'sleep':
        return Icons.bedtime;
      case 'blast':
        return Icons.local_fire_department;
      case 'exhaust':
        return Icons.air;
      default:
        return Icons.star;
    }
  }

  // Función para obtener el nombre del asset del elemento
  static String getElementAssetName(String element) {
    final elementLower = element.toLowerCase();
    if (elementLower.contains('fire')) return 'fire';
    if (elementLower.contains('water')) return 'water';
    if (elementLower.contains('ice')) return 'ice';
    if (elementLower.contains('thunder')) return 'thunder';
    if (elementLower.contains('dragon')) return 'dragon';
    if (elementLower.contains('poison')) return 'poison';
    if (elementLower.contains('paralysis')) return 'paralysis';
    if (elementLower.contains('sleep')) return 'sleep';
    if (elementLower.contains('blast')) return 'blast';
    return 'fire'; // default
  }

  // Función para verificar si un elemento tiene icono
  static bool hasElementIcon(String element) {
    final elementTypes = [
      'fire',
      'water',
      'ice',
      'thunder',
      'dragon',
      'poison',
      'paralysis',
      'sleep',
      'blast'
    ];
    return elementTypes.any((type) => element.toLowerCase().contains(type));
  }





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
