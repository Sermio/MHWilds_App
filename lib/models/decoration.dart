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
      name: json['name'] ?? "Unknown",
      description: json['description'] ?? "No description",
      value: json['value'] ?? 0,
      slot: json['slot'] ?? 0,
      rarity: json['rarity'] ?? 0,
      kind: json['kind'] ?? "Unknown",
      skills: json['skills'] != null
          ? (json['skills'] as List)
              .map((e) => DecorationSkill.fromJson(e))
              .toList()
          : [],
      id: json['id'] ?? 0,
      gameId: json['gameId'] ?? 0,
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
          : Skill(id: 0, name: "Unknown"),
      level: json['level'] ?? 0,
      description: json['description'] ?? "No description",
      id: json['id'] ?? 0,
    );
  }
}

class Skill {
  final int id;
  final String name;

  Skill({required this.id, required this.name});

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'] ?? 0,
      name: json['name'] ?? "Unknown",
    );
  }
}
