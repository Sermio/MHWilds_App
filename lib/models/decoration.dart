class DecorationItem {
  final String name;
  final String description;
  final int value;
  final int slot;
  final int rarity;
  final String kind;
  final List<DecorationSkill> skills;
  final int id;
  final int gameId;

  DecorationItem({
    required this.name,
    required this.description,
    required this.value,
    required this.slot,
    required this.rarity,
    required this.kind,
    required this.skills,
    required this.id,
    required this.gameId,
  });

  factory DecorationItem.fromJson(Map<String, dynamic> json) {
    return DecorationItem(
      name: json['name'] ?? "Unknown", // Valor por defecto si 'name' es nulo
      description: json['description'] ??
          "No description", // Valor por defecto si 'description' es nulo
      value: json['value'] ?? 0, // Valor por defecto si 'value' es nulo
      slot: json['slot'] ?? 0, // Valor por defecto si 'slot' es nulo
      rarity: json['rarity'] ?? 0, // Valor por defecto si 'rarity' es nulo
      kind: json['kind'] ?? "Unknown", // Valor por defecto si 'kind' es nulo
      skills: json['skills'] != null
          ? (json['skills'] as List)
              .map((e) => DecorationSkill.fromJson(e))
              .toList()
          : [], // Lista vacía si 'skills' es nulo
      id: json['id'] ?? 0, // Valor por defecto si 'id' es nulo
      gameId: json['gameId'] ?? 0, // Valor por defecto si 'gameId' es nulo
    );
  }
}

class DecorationSkill {
  final Skill skill;
  final int level;
  final String description;
  final int id;

  DecorationSkill({
    required this.skill,
    required this.level,
    required this.description,
    required this.id,
  });

  factory DecorationSkill.fromJson(Map<String, dynamic> json) {
    return DecorationSkill(
      skill: json['skill'] != null
          ? Skill.fromJson(json['skill'])
          : Skill(
              id: 0, name: "Unknown"), // Valor por defecto si 'skill' es nulo
      level: json['level'] ?? 0, // Valor por defecto si 'level' es nulo
      description: json['description'] ??
          "No description", // Valor por defecto si 'description' es nulo
      id: json['id'] ?? 0, // Valor por defecto si 'id' es nulo
    );
  }
}

class Skill {
  final int id;
  final String name;

  Skill({required this.id, required this.name});

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'] ?? 0, // Valor por defecto si 'id' es nulo
      name: json['name'] ?? "Unknown", // Valor por defecto si 'name' es nulo
    );
  }
}
