import 'package:flutter/material.dart';

class WeaponUtils {
  // Funciones para colores de elementos
  static Color getElementColor(String element) {
    switch (element.toLowerCase()) {
      case 'fire':
        return Colors.red[600]!;
      case 'water':
        return Colors.blue[600]!;
      case 'thunder':
        return Colors.yellow[600]!;
      case 'ice':
        return Colors.cyan[600]!;
      case 'dragon':
        return Colors.purple[600]!;
      case 'poison':
        return Colors.green[600]!;
      case 'paralysis':
        return Colors.amber[600]!;
      case 'sleep':
        return Colors.indigo[600]!;
      case 'blast':
        return Colors.orange[600]!;
      case 'exhaust':
        return Colors.grey[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

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

  // Función para colores de coatings
  static Color getCoatingColor(String coating) {
    switch (coating.toLowerCase()) {
      case 'power':
        return Colors.red[600]!;
      case 'paralysis':
        return Colors.amber[600]!;
      case 'poison':
        return Colors.green[600]!;
      case 'sleep':
        return Colors.indigo[600]!;
      case 'blast':
        return Colors.orange[600]!;
      case 'exhaust':
        return Colors.grey[600]!;
      case 'close-range':
        return Colors.blue[600]!;
      case 'pierce':
        return Colors.purple[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  // Función para colores de slots
  static Color getSlotColor(int level) {
    switch (level) {
      case 1:
        return Colors.grey[400]!;
      case 2:
        return Colors.green[400]!;
      case 3:
        return Colors.blue[400]!;
      case 4:
        return Colors.purple[400]!;
      default:
        return Colors.grey[400]!;
    }
  }

  // Función para colores de rareza
  static Color getRarityColor(int rarity) {
    switch (rarity) {
      case 1:
        return Colors.grey[400]!;
      case 2:
        return Colors.green[400]!;
      case 3:
        return Colors.blue[400]!;
      case 4:
        return Colors.purple[400]!;
      case 5:
        return Colors.orange[400]!;
      case 6:
        return Colors.red[400]!;
      case 7:
        return Colors.amber[400]!;
      default:
        return Colors.grey[400]!;
    }
  }

  // Función para colores de tipo de arma
  static Color getKindColor(String kind) {
    switch (kind) {
      case 'great-sword':
        return Colors.red[400]!;
      case 'long-sword':
        return Colors.orange[400]!;
      case 'sword-shield':
        return Colors.blue[400]!;
      case 'dual-blades':
        return Colors.purple[400]!;
      case 'hammer':
        return Colors.brown[400]!;
      case 'hunting-horn':
        return Colors.green[400]!;
      case 'lance':
        return Colors.indigo[400]!;
      case 'gunlance':
        return Colors.teal[400]!;
      case 'switch-axe':
        return Colors.deepOrange[400]!;
      case 'charge-blade':
        return Colors.cyan[400]!;
      case 'insect-glaive':
        return Colors.lime[400]!;
      case 'bow':
        return Colors.amber[400]!;
      case 'light-bowgun':
        return Colors.pink[400]!;
      case 'heavy-bowgun':
        return Colors.deepPurple[400]!;
      default:
        return Colors.grey[400]!;
    }
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
