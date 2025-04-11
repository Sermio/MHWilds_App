import 'package:mhwilds_app/models/item.dart';
import 'package:mhwilds_app/models/skills.dart';

class ArmorPiece {
  final String kind;
  final String name;
  final String description;
  final String rank;
  final int rarity;
  final Map<String, int> resistances;
  final Map<String, int> defense;
  final List<SkillInfo> skills;
  final List<int> slots;
  final ArmorSet armorSet;
  final Crafting crafting;
  final int id;

  ArmorPiece({
    required this.kind,
    required this.name,
    required this.description,
    required this.rank,
    required this.rarity,
    required this.resistances,
    required this.defense,
    required this.skills,
    required this.slots,
    required this.armorSet,
    required this.crafting,
    required this.id,
  });

  factory ArmorPiece.fromJson(Map<String, dynamic> json) {
    return ArmorPiece(
      kind: json['kind'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      rank: json['rank'] as String? ?? '',
      rarity: json['rarity'] as int? ?? 0,
      resistances: Map<String, int>.from(json['resistances'] ?? {}),
      defense: Map<String, int>.from(json['defense'] ?? {}),
      skills: (json['skills'] as List? ?? [])
          .map((skillJson) => SkillInfo.fromJson(skillJson))
          .toList(),
      slots: (json['slots'] as List? ?? []).map((e) => e as int).toList(),
      armorSet: ArmorSet.fromJson(json['armorSet'] ?? {}),
      crafting: Crafting.fromJson(json['crafting'] ?? {}),
      id: json['id'] as int? ?? 0,
    );
  }
}

class SkillInfo {
  final Skills skill;
  final int level;
  final String description;
  final int id;

  SkillInfo({
    required this.skill,
    required this.level,
    required this.description,
    required this.id,
  });

  factory SkillInfo.fromJson(Map<String, dynamic> json) {
    return SkillInfo(
      skill: Skills.fromJson(json['skill'] ?? {}),
      level: json['level'] as int? ?? 0,
      description: json['description'] as String? ?? '',
      id: json['id'] as int? ?? 0,
    );
  }
}

class ArmorSet {
  final int id;
  final String name;

  ArmorSet({
    required this.id,
    required this.name,
  });

  factory ArmorSet.fromJson(Map<String, dynamic> json) {
    return ArmorSet(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
    );
  }
}

class Crafting {
  final Armor armor;
  final List<Material> materials;
  final int zennyCost;
  final int id;

  Crafting({
    required this.armor,
    required this.materials,
    required this.zennyCost,
    required this.id,
  });

  factory Crafting.fromJson(Map<String, dynamic> json) {
    return Crafting(
      armor: Armor.fromJson(json['armor'] ?? {}),
      materials: (json['materials'] as List? ?? [])
          .map((materialJson) => Material.fromJson(materialJson))
          .toList(),
      zennyCost: json['zennyCost'] as int? ?? 0,
      id: json['id'] as int? ?? 0,
    );
  }
}

class Armor {
  final int id;

  Armor({
    required this.id,
  });

  factory Armor.fromJson(Map<String, dynamic> json) {
    return Armor(
      id: json['id'] as int? ?? 0,
    );
  }
}

class Material {
  final Item item;
  final int quantity;
  final int id;

  Material({
    required this.item,
    required this.quantity,
    required this.id,
  });

  factory Material.fromJson(Map<String, dynamic> json) {
    return Material(
      item: Item.fromJson(json['item'] ?? {}),
      quantity: json['quantity'] as int? ?? 0,
      id: json['id'] as int? ?? 0,
    );
  }
}
