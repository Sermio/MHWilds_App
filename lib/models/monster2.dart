class Monster2 {
  final int id;
  final String kind;
  final String species;
  final List<String> elements;
  final String name;
  final String description;
  final List<Ailment> ailments; // Cambiado de dynamic a Ailment
  final List<Location> locations; // Cambiado de dynamic a Location
  final List<Resistance> resistances;
  final List<Weakness> weaknesses;
  final List<Reward> rewards;

  Monster2({
    required this.id,
    required this.kind,
    required this.species,
    required this.elements,
    required this.name,
    required this.description,
    required this.ailments,
    required this.locations,
    required this.resistances,
    required this.weaknesses,
    required this.rewards,
  });

  factory Monster2.fromJson(Map<String, dynamic> json) {
    return Monster2(
      id: json['id'] ?? 0,
      kind: json['kind'] ?? '',
      species: json['species'] ?? '',
      elements: List<String>.from(json['elements'] ?? []),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
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
  final String kind; // 'element', 'status', 'effect', etc.
  final String? element; // Solo se usa si kind == 'element'
  final String? status; // Solo se usa si kind == 'status'
  final String? effect; // Solo se usa si kind == 'effect'
  final int level; // Nivel de la debilidad (1, 2, etc.)
  final String? condition; // Condición adicional para algunas debilidades

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
      element: json['element'], // Puede ser null, solo si kind == 'element'
      status: json['status'], // Puede ser null, solo si kind == 'status'
      effect: json['effect'], // Puede ser null, solo si kind == 'effect'
      level: json['level'] ?? 0,
      condition: json['condition'], // Puede ser null si no hay condición
    );
  }
}

class Reward {
  final int id;
  final RewardItem item;
  final List<RewardCondition> conditions;

  Reward({
    required this.id,
    required this.item,
    required this.conditions,
  });

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      id: json['id'] ?? 0,
      item: RewardItem.fromJson(json['item'] ?? {}),
      conditions: (json['conditions'] as List<dynamic>? ?? [])
          .map((e) => RewardCondition.fromJson(e))
          .toList(),
    );
  }
}

class RewardItem {
  final int id;
  final int rarity;
  final int carryLimit;
  final int value;
  final String name;
  final String description;

  RewardItem({
    required this.id,
    required this.rarity,
    required this.carryLimit,
    required this.value,
    required this.name,
    required this.description,
  });

  factory RewardItem.fromJson(Map<String, dynamic> json) {
    return RewardItem(
      id: json['id'] ?? 0,
      rarity: json['rarity'] ?? 0,
      carryLimit: json['carryLimit'] ?? 0,
      value: json['value'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class RewardCondition {
  final String kind;
  final String rank;
  final int quantity;
  final int chance;
  final String? subtype;

  RewardCondition({
    required this.kind,
    required this.rank,
    required this.quantity,
    required this.chance,
    this.subtype,
  });

  factory RewardCondition.fromJson(Map<String, dynamic> json) {
    return RewardCondition(
      kind: json['kind'] ?? '',
      rank: json['rank'] ?? '',
      quantity: json['quantity'] ?? 0,
      chance: json['chance'] ?? 0,
      subtype: json['subtype'],
    );
  }
}
