class Skills {
  final int id;
  final int gameId;
  final String name;
  final String kind;
  final String description;
  final List<Rank> ranks;

  Skills({
    required this.id,
    required this.gameId,
    required this.name,
    required this.kind,
    required this.description,
    required this.ranks,
  });

  factory Skills.fromJson(Map<String, dynamic> json) {
    return Skills(
      id: json['id'] as int,
      gameId: json['gameId'] as int,
      name: json['name'] as String,
      kind: json['kind'] as String,
      description: json['description'] as String? ?? 'No description available',
      ranks: (json['ranks'] as List)
          .map((rank) => Rank.fromJson(rank as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Rank {
  final int id;
  final int level;
  final String description;
  final Skill skill;

  Rank({
    required this.id,
    required this.level,
    required this.description,
    required this.skill,
  });

  factory Rank.fromJson(Map<String, dynamic> json) {
    return Rank(
      id: json['id'] as int,
      level: json['level'] as int,
      description: json['description'] as String,
      skill: Skill.fromJson(json['skill'] as Map<String, dynamic>),
    );
  }
}

class Skill {
  final int id;

  Skill({
    required this.id,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'] as int,
    );
  }
}
