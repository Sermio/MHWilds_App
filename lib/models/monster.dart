import 'package:mhwilds_app/models/item.dart';

class Monster {
  final int id;
  final String kind;
  final String species;
  final List<String> elements;
  final String name;
  final String description;
  final String features;
  final String tips;
  final int baseHealth;
  final List<Ailment> ailments;
  final List<Location> locations;
  final List<Resistance> resistances;
  final List<Weakness> weaknesses;
  final List<Reward> rewards;
  final List<MonsterVariant> variants;
  final List<BreakablePart> breakableParts;

  Monster({
    required this.id,
    required this.kind,
    required this.species,
    required this.elements,
    required this.name,
    required this.description,
    required this.features,
    required this.tips,
    required this.baseHealth,
    required this.ailments,
    required this.locations,
    required this.resistances,
    required this.weaknesses,
    required this.rewards,
    required this.variants,
    required this.breakableParts,
  });

  factory Monster.fromJson(Map<String, dynamic> json) {
    return Monster(
      id: json['id'] ?? 0,
      kind: json['kind'] ?? '',
      species: json['species'] ?? '',
      elements: List<String>.from(json['elements'] ?? []),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      features: json['features'] ?? '',
      tips: json['tips'] ?? '',
      baseHealth: json['baseHealth'] ?? 0,
      ailments: (json['ailments'] as List<dynamic>? ?? [])
          .map((e) => Ailment.fromJson(e))
          .toList(),
      locations: (json['locations'] as List<dynamic>? ?? [])
          .map((e) => Location.fromJson(e))
          .toList(),
      resistances: (json['resistances'] as List<dynamic>? ?? [])
          .map((e) => Resistance.fromJson(e))
          .toList(),
      weaknesses: (json['weaknesses'] as List<dynamic>? ?? [])
          .map((e) => Weakness.fromJson(e))
          .toList(),
      rewards: (json['rewards'] as List<dynamic>? ?? [])
          .map((e) => Reward.fromJson(e))
          .toList(),
      variants: (json['variants'] as List<dynamic>? ?? [])
          .map((e) => MonsterVariant.fromJson(e))
          .toList(),
      breakableParts: (json['breakableParts'] as List<dynamic>? ?? [])
          .map((e) => BreakablePart.fromJson(e))
          .toList(),
    );
  }
}

class Ailment {
  final int id;
  final String name;
  final String description;
  final Recovery recovery;
  final Protection protection;

  Ailment({
    required this.id,
    required this.name,
    required this.description,
    required this.recovery,
    required this.protection,
  });

  factory Ailment.fromJson(Map<String, dynamic> json) {
    return Ailment(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      recovery: Recovery.fromJson(json['recovery'] ?? {}),
      protection: Protection.fromJson(json['protection'] ?? {}),
    );
  }
}

class Recovery {
  final List<String> actions;
  final List<dynamic> items;

  Recovery({
    required this.actions,
    required this.items,
  });

  factory Recovery.fromJson(Map<String, dynamic> json) {
    return Recovery(
      actions: List<String>.from(json['actions'] ?? []),
      items: json['items'] ?? [],
    );
  }
}

class Protection {
  final List<dynamic> items;
  final List<Skill> skills;

  Protection({
    required this.items,
    required this.skills,
  });

  factory Protection.fromJson(Map<String, dynamic> json) {
    return Protection(
      items: json['items'] ?? [],
      skills: (json['skills'] as List<dynamic>? ?? [])
          .map((e) => Skill.fromJson(e))
          .toList(),
    );
  }
}

class Skill {
  final int id;
  final String name;
  final String description;

  Skill({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class Location {
  final String name;
  final int zoneCount;
  final int id;
  final int gameId;

  Location({
    required this.name,
    required this.zoneCount,
    required this.id,
    required this.gameId,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'] ?? '',
      zoneCount: json['zoneCount'] ?? 0,
      id: json['id'] ?? 0,
      gameId: json['gameId'] ?? 0,
    );
  }
}

class Resistance {
  final String kind;
  final String element;
  final String? condition;

  Resistance({
    required this.kind,
    required this.element,
    this.condition,
  });

  factory Resistance.fromJson(Map<String, dynamic> json) {
    return Resistance(
      kind: json['kind'] ?? '',
      element: json['element'] ?? '',
      condition: json['condition'],
    );
  }
}

class Weakness {
  final String kind;
  final String? element;
  final String? status;
  final String? effect;
  final int level;
  final String? condition;

  Weakness({
    required this.kind,
    this.element,
    this.status,
    this.effect,
    required this.level,
    this.condition,
  });

  factory Weakness.fromJson(Map<String, dynamic> json) {
    return Weakness(
      kind: json['kind'] ?? '',
      element: json['element'],
      status: json['status'],
      effect: json['effect'],
      level: json['level'] ?? 0,
      condition: json['condition'],
    );
  }
}

class Reward {
  final int id;
  final Item item;
  final List<RewardCondition> conditions;

  Reward({
    required this.id,
    required this.item,
    required this.conditions,
  });

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      id: json['id'] ?? 0,
      item: Item.fromJson(json['item'] ?? {}),
      conditions: (json['conditions'] as List<dynamic>? ?? [])
          .map((e) => RewardCondition.fromJson(e))
          .toList(),
    );
  }
}

class RewardCondition {
  final String kind;
  final String rank;
  final int quantity;
  final int chance;
  final String? subtype;
  final String? part;
  final int id;

  RewardCondition({
    required this.kind,
    required this.rank,
    required this.quantity,
    required this.chance,
    this.subtype,
    this.part,
    required this.id,
  });

  factory RewardCondition.fromJson(Map<String, dynamic> json) {
    return RewardCondition(
      kind: json['kind'] ?? '',
      rank: json['rank'] ?? '',
      quantity: json['quantity'] ?? 0,
      chance: json['chance'] ?? 0,
      subtype: json['subtype'],
      part: json['part'],
      id: json['id'] ?? 0,
    );
  }
}

class MonsterVariant {
  final int id;
  final String name;
  final String kind;
  final int monsterId;

  MonsterVariant({
    required this.id,
    required this.name,
    required this.kind,
    required this.monsterId,
  });

  factory MonsterVariant.fromJson(Map<String, dynamic> json) {
    return MonsterVariant(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      kind: json['kind'] ?? '',
      monsterId: json['monster']?['id'] ?? 0,
    );
  }
}

class BreakablePart {
  final int id;
  final String name;
  final String part;
  final int monsterId;

  BreakablePart({
    required this.id,
    required this.name,
    required this.part,
    required this.monsterId,
  });

  factory BreakablePart.fromJson(Map<String, dynamic> json) {
    return BreakablePart(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      part: json['part'] ?? '',
      monsterId: json['monster']?['id'] ?? 0,
    );
  }
}
