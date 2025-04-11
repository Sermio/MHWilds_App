import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:image/image.dart' as img;

final Map<String, String?> _skillImageUrlCache = {};

Future<bool> isGrayScaleFromUrl(String imageUrl) async {
  try {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode != 200) {
      throw Exception('Error al descargar la imagen');
    }

    Uint8List bytes = response.bodyBytes;
    img.Image? image = img.decodeImage(bytes);
    if (image == null) {
      throw Exception('No se pudo decodificar la imagen');
    }

    int grayscalePixels = 0;
    int totalPixels = 0;

    for (int y = 0; y < image.height; y += 10) {
      for (int x = 0; x < image.width; x += 10) {
        img.Pixel pixel = image.getPixel(x, y);
        int r = pixel.r as int;
        int g = pixel.g as int;
        int b = pixel.b as int;

        if ((r - g).abs() < 5 && (r - b).abs() < 5 && (g - b).abs() < 5) {
          grayscalePixels++;
        }
        totalPixels++;
      }
    }

    return (grayscalePixels / totalPixels) > 0.9;
  } catch (e) {
    // ignore: avoid_print
    print('Error al procesar la imagen: $e');
    return false;
  }
}

Future<String?> getSkillUrl(String skillName, int slot, int skillLevel) async {
  int jewelIndex = skillName.toLowerCase().indexOf('jewel');
  int slashIndex = skillName.indexOf('/');
  int numberOfIs = countRomanNumerals(skillName);
  String fillIs = "";
  if (skillName.contains("/")) {
    fillIs = "iii";
  }
  if (skillName.toLowerCase().contains("artillery")) {
    // ignore: avoid_print
    print("");
  }

  int cutIndex = -1;

  if (slashIndex != -1) {
    int spaceIndex = skillName.indexOf(' ', slashIndex);
    String firstPart = skillName.substring(0, slashIndex).trim();
    String secondPart =
        spaceIndex != -1 ? skillName.substring(spaceIndex).trim() : '';

    skillName = '$firstPart $secondPart';
  }

  if (jewelIndex != -1 && slashIndex != -1) {
    cutIndex = jewelIndex < slashIndex ? jewelIndex : slashIndex;
  } else if (jewelIndex != -1) {
    cutIndex = jewelIndex;
  } else if (slashIndex != -1) {
    cutIndex = slashIndex;
  }

  String baseSkillName = cutIndex != -1
      ? skillName.substring(0, cutIndex).trim().toLowerCase()
      : skillName.trim().toLowerCase();

  if (numberOfIs == 2) {
    fillIs = "ii";
  } else if (numberOfIs == 3) {
    fillIs = "iii";
  } else if (numberOfIs == 2) {
    fillIs = "ii";
  } else if (numberOfIs == 3) {
    fillIs = "iii";
  }

  baseSkillName = baseSkillName.replaceAll(' ', '');
  List<String> urlVariations = [
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${baseSkillName}jewel${fillIs}_${slot}_decoration__mhwilds_wiki_guide.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${baseSkillName}_jewel${fillIs}_${slot}_decoration__mhwilds_wiki_guide.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${baseSkillName}jewel_${fillIs}_${slot}_decoration__mhwilds_wiki_guide.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${baseSkillName}_jewel_${fillIs}_${slot}_decoration__mhwilds_wiki_guide.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${baseSkillName}jewel${fillIs}_${slot}_decoration_mhwilds_wiki_guide.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${baseSkillName}_jewel${fillIs}_${slot}_decoration_mhwilds_wiki_guide.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${baseSkillName}jewel_${fillIs}_${slot}_decoration_mhwilds_wiki_guide.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${baseSkillName}_jewel_${fillIs}_${slot}_decoration_mhwilds_wiki_guide.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${baseSkillName}jewel${fillIs}_${slot}__mhwilds_wiki_guide.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${baseSkillName}_jewel${fillIs}_${slot}__mhwilds_wiki_guide.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${baseSkillName}jewel_${fillIs}_${slot}__mhwilds_wiki_guide.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${baseSkillName}_jewel_${fillIs}_${slot}__mhwilds_wiki_guide.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${baseSkillName}jewel${fillIs}_${slot}_mhwilds_wiki_guide.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${baseSkillName}_jewel${fillIs}_${slot}_mhwilds_wiki_guide.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${baseSkillName}jewel_${fillIs}_${slot}_mhwilds_wiki_guide.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${baseSkillName}_jewel_${fillIs}_${slot}_mhwilds_wiki_guide.png",
  ];

  for (String url in urlVariations) {
    final response = await http.head(Uri.parse(url));
    if (response.statusCode == 200) {
      bool isGrayscale = await isGrayScaleFromUrl(url);
      if (!isGrayscale) {
        return url;
      }
    }
  }

  return null;
}

int countRomanNumerals(String skillName) {
  RegExp regExp = RegExp(r'(?<=\s)I{1,3}(?=\s|$)');

  Match? match = regExp.firstMatch(skillName);
  if (match != null) {
    return match.group(0)!.length;
  }
  return 0;
}

Color zoneBackgroundColor(String zone) {
  switch (zone) {
    case 'Scarlet Forest':
      return Colors.green.shade700;
    case 'Oilwell Basin':
      return const Color.fromARGB(242, 142, 141, 141);
    case 'Ruins of Wyveria':
      return const Color.fromARGB(221, 141, 110, 99);
    case "Windward Plains":
      return const Color.fromARGB(255, 249, 207, 37);
    case "Iceshard Cliffs":
      return const Color.fromARGB(167, 1, 150, 170);
    default:
      return Colors.white;
  }
}

Future<String?> getValidMonsterImageUrl(String monsterName) async {
  List<String> urlVariations = [
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/arkveld2_monster_monterhunsterwilds_wiki_guide300px.png"
  ];

  for (String url in urlVariations) {
    final response = await http.head(Uri.parse(url));

    if (response.statusCode == 200) {
      return url;
    }
  }

  return null;
}

Future<String?> getValidItemImageUrl(String materialName) async {
  // String formattedMaterialName = materialName.replaceAll(RegExp(r'\s\+'), '+');

  List<String> urlVariations = [
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${materialName}_item_equipment_material_mhwilds_wiki_guide_85px.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${materialName}_item_healing_support_mhwilds_wiki_guide_85px.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${materialName}_item_ingredient_mhwilds_wiki_guide_85px.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${materialName}_item_trap_offense_mhwilds_wiki_guide_85px.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${materialName}_item_bowgun_ammo_mhwilds_wiki_guide_85px.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${materialName}_item_special_items_other_mhwilds_wiki_guide_85px.png",
  ];

  for (String url in urlVariations) {
    final response = await http.head(Uri.parse(url));

    if (response.statusCode == 200) {
      return url;
    }
  }

  return null;
}

Future<String?> getValidSkillImageUrl(String skillName) async {
  String formattedSkillName = skillName
      .toLowerCase()
      .replaceAll(' ', '-')
      .replaceAll("'", '')
      .replaceAll('-', '_');

  if (_skillImageUrlCache.containsKey(formattedSkillName)) {
    return _skillImageUrlCache[formattedSkillName];
  }

  List<String> urlVariations = [
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${formattedSkillName}_skill_mhwilds_wiki_guide_85px.png",
  ];

  const int maxRetries = 4;
  const Duration timeoutDuration = Duration(seconds: 2);

  for (String url in urlVariations) {
    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        final response =
            await http.head(Uri.parse(url)).timeout(timeoutDuration);
        if (response.statusCode == 200) {
          _skillImageUrlCache[formattedSkillName] = url;
          return url;
        }
      } catch (_) {
        if (attempt == maxRetries - 1) {
          // ignore: avoid_print
          print(
              "Error al cargar imagen en $url después de $maxRetries intentos.");
        }
      }
    }
  }

  const fallbackUrl =
      'https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/attack_boost_skill_mhwilds_wiki_guide_85px.png';

  _skillImageUrlCache[formattedSkillName] = fallbackUrl;
  return fallbackUrl;
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
