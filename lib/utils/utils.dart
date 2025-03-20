import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<String?> getSkillUrl(String skillName, int slot, int skillLevel) async {
  int jewelIndex = skillName.toLowerCase().indexOf('jewel');

  int slashIndex = skillName.indexOf('/');

  int numberOfIs = countRomanNumerals(skillName);

  String fillIs = "";

  int cutIndex = -1;
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
  }

  if (skillLevel == 2) {
    fillIs = "ii";
  } else if (skillLevel == 3) {
    fillIs = "iii";
  }

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
    case 'Ancient Forest':
      return Colors.green.shade500;
    case 'Coral Highlands':
      return Colors.pink.shade100;
    case 'Wildspire Waste':
      return Colors.yellow.shade700;
    case 'Rotten Vale':
      return Colors.brown.shade200;
    case "Elder's Recess":
      return Colors.grey.shade300;
    case "Caverns of El Dorado":
      return Colors.yellow;
    case "Confluence of Fates":
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
