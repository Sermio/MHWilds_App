import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<String?> getSkillUrl(String skillName, int slot, int skillLevel) async {
  int jewelIndex = skillName.toLowerCase().indexOf('jewel');
  int slashIndex = skillName.indexOf('/');
  int numberOfIs = countRomanNumerals(skillName);
  String fillIs = "";
  if (skillName.contains("/")) {
    fillIs = "iii";
  }

  int cutIndex = -1;

  if (skillName.toLowerCase().contains('blast')) {
    print('ola');
  }

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
    print(url);

    if (response.statusCode == 200) {
      print(url);
      return url;
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
      return Colors.green.shade500;
    case 'Oilwell Basin':
      return Colors.pink.shade100;
    case 'Ruins Of Wyveria':
      return Colors.yellow.shade700;
    case "Windward Plains":
      return Colors.yellow;
    case "Iceshard Cliffs":
      return Colors.cyan.shade100;
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

Future<String?> getValidSkillImageUrl(String decorationName) async {
  List<String> urlVariations = [
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${decorationName.toLowerCase().replaceAll(' ', '-')}_skill_mhwilds_wiki_guide_85px.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${decorationName.toLowerCase().replaceAll(' ', '_')}_skill_mhwilds_wiki_guide_85px.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${decorationName.toLowerCase().replaceAll(' ', '-')}_skill_mhwilds_wiki_guide_85px.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${decorationName.toLowerCase().replaceAll(' ', '_')}_skill_mhwilds_wiki_guide_85px.png",
  ];

  const int maxRetries = 4;
  const Duration timeoutDuration = Duration(seconds: 2);

  for (String url in urlVariations) {
    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        final response =
            await http.head(Uri.parse(url)).timeout(timeoutDuration);
        if (response.statusCode == 200) {
          return url;
        }
      } catch (e) {
        if (attempt == maxRetries - 1) {
          print(
              "Error al cargar imagen en $url después de $maxRetries intentos.");
        }
      }
    }
  }

  return 'https://monsterhunterworld.wiki.fextralife.com/file/Monster-Hunter-World/evade-window-skill-mhw.png';
}
