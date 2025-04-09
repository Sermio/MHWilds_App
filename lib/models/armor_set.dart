import 'package:mhwilds_app/models/item.dart';

class ArmorPiece {
  final String kind;
  final String name;
  final String description;
  final String rank;
  final int rarity;
  final Map<String, int> resistances;
  final Map<String, int> defense;
  final List<Skill> skills;
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
      kind: json['kind'] ?? 'Unknown',
      name: json['name'] ?? 'Unnamed',
      description: json['description'] ?? 'No description available',
      rank: json['rank'] ?? 'Unknown',
      rarity: json['rarity'] ?? 0,
      resistances: Map<String, int>.from(json['resistances'] ?? {}),
      defense: Map<String, int>.from(json['defense'] ?? {}),
      skills: (json['skills'] as List?)
              ?.map((skillJson) => Skill.fromJson(skillJson['skill'] ?? {}))
              .toList() ??
          [],
      slots: List<int>.from(json['slots'] ?? []),
      armorSet: ArmorSet.fromJson(json['armorSet'] ?? {}),
      crafting: Crafting.fromJson(json['crafting'] ?? {}),
      id: json['id'] ?? 0,
    );
  }
}

class Skill {
  final int id;
  final int gameId;
  final String name;

  Skill({
    required this.id,
    required this.gameId,
    required this.name,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'] ?? 0,
      gameId: json['gameId'] ?? 0,
      name: json['name'] ?? 'Unknown',
    );
  }
}

class ArmorSetBonus {
  final int id;
  final Skill skill;
  final List<BonusRank> ranks;

  ArmorSetBonus({
    required this.id,
    required this.skill,
    required this.ranks,
  });

  factory ArmorSetBonus.fromJson(Map<String, dynamic> json) {
    return ArmorSetBonus(
      id: json['id'] ?? 0,
      skill: Skill.fromJson(json['skill'] ?? {}),
      ranks: (json['ranks'] as List?)
              ?.map((rankJson) => BonusRank.fromJson(rankJson ?? {}))
              .toList() ??
          [],
    );
  }
}

class BonusRank {
  final Bonus bonus;
  final int pieces;
  final Skill skill;
  final int id;

  BonusRank({
    required this.bonus,
    required this.pieces,
    required this.skill,
    required this.id,
  });

  factory BonusRank.fromJson(Map<String, dynamic> json) {
    return BonusRank(
      bonus: Bonus.fromJson(json['bonus'] ?? {}),
      pieces: json['pieces'] ?? 0,
      skill: Skill.fromJson(json['skill'] ?? {}),
      id: json['id'] ?? 0,
    );
  }
}

class Bonus {
  final int id;

  Bonus({
    required this.id,
  });

  factory Bonus.fromJson(Map<String, dynamic> json) {
    return Bonus(
      id: json['id'] ?? 0,
    );
  }
}

class ArmorSetGroupBonus {
  final int id;
  final ArmorSetBonus? groupBonus;

  ArmorSetGroupBonus({
    required this.id,
    this.groupBonus,
  });

  factory ArmorSetGroupBonus.fromJson(Map<String, dynamic> json) {
    return ArmorSetGroupBonus(
      id: json['id'] ?? 0,
      groupBonus: json['groupBonus'] != null
          ? ArmorSetBonus.fromJson(json['groupBonus'])
          : null,
    );
  }
}

class ArmorSet {
  final String name;
  List<ArmorPiece> pieces;
  final ArmorSetBonus? bonus;
  final ArmorSetGroupBonus groupBonus;
  final int id;
  final int gameId;

  ArmorSet({
    required this.name,
    required this.pieces,
    this.bonus,
    required this.groupBonus,
    required this.id,
    required this.gameId,
  });
  ArmorSet copy() {
    return ArmorSet(
      id: id,
      name: name,
      gameId: gameId,
      groupBonus: groupBonus,
      pieces: List.from(pieces),
    );
  }

  factory ArmorSet.fromJson(Map<String, dynamic> json) {
    return ArmorSet(
      name: json['name'] ?? 'Unknown Set',
      pieces: (json['pieces'] as List?)
              ?.map((pieceJson) => ArmorPiece.fromJson(pieceJson ?? {}))
              .toList() ??
          [],
      bonus: json['bonus'] != null
          ? ArmorSetBonus.fromJson(json['bonus'] ?? {})
          : null,
      groupBonus: ArmorSetGroupBonus.fromJson(json['groupBonus'] ?? {}),
      id: json['id'] ?? 0,
      gameId: json['gameId'] ?? 0,
    );
  }
}

class Crafting {
  final ArmorCraftingArmor armor;
  final List<CraftingMaterial> materials;
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
      armor: ArmorCraftingArmor.fromJson(json['armor'] ?? {}),
      materials: (json['materials'] as List?)
              ?.map((materialJson) =>
                  CraftingMaterial.fromJson(materialJson ?? {}))
              .toList() ??
          [],
      zennyCost: json['zennyCost'] ?? 0,
      id: json['id'] ?? 0,
    );
  }
}

class ArmorCraftingArmor {
  final int id;

  ArmorCraftingArmor({
    required this.id,
  });

  factory ArmorCraftingArmor.fromJson(Map<String, dynamic> json) {
    return ArmorCraftingArmor(
      id: json['id'] ?? 0,
    );
  }
}

class CraftingMaterial {
  final Item item;
  final int quantity;
  final int id;

  CraftingMaterial({
    required this.item,
    required this.quantity,
    required this.id,
  });

  factory CraftingMaterial.fromJson(Map<String, dynamic> json) {
    return CraftingMaterial(
      item: Item.fromJson(json['item'] ?? {}),
      quantity: json['quantity'] ?? 0,
      id: json['id'] ?? 0,
    );
  }
}
