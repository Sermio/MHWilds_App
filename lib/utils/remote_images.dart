import 'package:flutter/foundation.dart';
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
