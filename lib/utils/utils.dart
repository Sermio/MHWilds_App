import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<String?> getValidItemImageUrl(String materialName) async {
  // String formattedMaterialName = materialName.replaceAll(RegExp(r'\s\+'), '+');

  final List<String> urlVariations = [
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${materialName}_item_equipment_material_mhwilds_wiki_guide_85px.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${materialName}_item_healing_support_mhwilds_wiki_guide_85px.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${materialName}_item_ingredient_mhwilds_wiki_guide_85px.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${materialName}_item_trap_offense_mhwilds_wiki_guide_85px.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${materialName}_item_bowgun_ammo_mhwilds_wiki_guide_85px.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${materialName}_item_special_items_other_mhwilds_wiki_guide_85px.png",
  ];

  for (String url in urlVariations) {
    try {
      final response = await http.head(Uri.parse(url));

      if (response.statusCode == 200) {
        return url;
      }
    } catch (e) {
      // Si falla (ej. CORS en Web, sin internet), ignoramos esta URL
      // ignore: avoid_print
      debugPrint('Network error for $url: $e');
    }
  }

  return null;
}

String getTypeImage(String skillKind) {
  switch (skillKind) {
    case 'weapon':
      return 'assets/imgs/weapons/artian.webp';
    case 'armor':
      return 'assets/imgs/drawer/armor.webp';
    case 'group':
      return 'assets/imgs/armor/chest/group_armor.webp';
    case 'set':
      return 'assets/imgs/armor/chest/set_armor.webp';
    default:
      return 'assets/imgs/weapons/artian.webp';
  }
}

Widget getJewelSlotIcon(int slot) {
  if (slot == 1) {
    return Image.asset('assets/imgs/decorations/gem_level_1.png');
  }
  if (slot == 2) {
    return Image.asset('assets/imgs/decorations/gem_level_2.png');
  }
  if (slot == 3) {
    return Image.asset('assets/imgs/decorations/gem_level_3.png');
  }
  if (slot == 4) {
    return Image.asset('assets/imgs/decorations/gem_level_4.png');
  }
  return Image.asset('assets/imgs/decorations/gem_level_1.png');
}

String getKindImage(String skillKind) {
  switch (skillKind) {
    case 'head':
      return 'assets/imgs/armor/head/rarity8.webp';
    case 'chest':
      return 'assets/imgs/armor/chest/rarity8.webp';
    case 'arms':
      return 'assets/imgs/armor/arms/rarity8.webp';
    case 'waist':
      return 'assets/imgs/armor/waist/rarity8.webp';
    case 'legs':
      return 'assets/imgs/armor/legs/rarity8.webp';
    default:
      return 'assets/imgs/armor/chest/rarity8.webp';
  }
}

const _diacriticsMap = {
  'ÀÁÂÃÄÅ': 'A', 'àáâãäå': 'a', 'ÒÓÔÕÖØ': 'O', 'òóôõöø': 'o',
  'ÈÉÊË': 'E', 'èéêë': 'e', 'Çç': 'C', 'ÌÍÎÏ': 'I', 'ìíîï': 'i',
  'ÙÚÛÜ': 'U', 'ùúûü': 'u', 'ÿ': 'y', 'Ññ': 'N',
};

final Map<int, String> _diacriticsByCodeUnit = {
  for (final e in _diacriticsMap.entries)
    for (final c in e.key.split('')) c.codeUnitAt(0): e.value,
};

/// Minúsculas, sin tildes y sin espacios en los extremos, en un solo recorrido.
/// La ñ se pliega a n (como antes) para que "nino" encuentre "niño".
String removeDiacritics(String text) {
  final out = StringBuffer();
  for (final unit in text.codeUnits) {
    out.write(_diacriticsByCodeUnit[unit] ?? String.fromCharCode(unit));
  }
  return out.toString().toLowerCase().trim();
}
