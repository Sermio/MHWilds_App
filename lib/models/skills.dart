class Skills {
  final int id;
  final int gameId;
  final String name;
  final String kind;
  final String description;
  final List<Rank> ranks;
  final SkillIcon? icon;

  Skills({
    required this.id,
    required this.gameId,
    required this.name,
    required this.kind,
    required this.description,
    required this.ranks,
    this.icon,
  });

  factory Skills.fromJson(Map<String, dynamic> json) {
    return Skills(
      id: json['id'] is int ? json['id'] as int : 0,
      gameId: json['gameId'] is int ? json['gameId'] as int : 0,
      name: json['name'] as String? ?? 'Unknown',
      kind: json['kind'] as String? ?? 'Unknown',
      description: json['description'] as String? ?? 'No description available',
      ranks: (json['ranks'] as List?)
              ?.map((rank) => Rank.fromJson(rank as Map<String, dynamic>))
              .toList() ??
          [],
      icon: json['icon'] != null
          ? SkillIcon.fromJson(json['icon'] as Map<String, dynamic>)
          : null,
    );
  }
}

class SkillIcon {
  final int id;
  final String kind;

  SkillIcon({
    required this.id,
    required this.kind,
  });

  factory SkillIcon.fromJson(Map<String, dynamic> json) {
    return SkillIcon(
      id: json['id'] is int ? json['id'] as int : 0,
      kind: json['kind'] as String? ?? '',
    );
  }
}

class Rank {
  final int id;
  final int level;
  final String description;
  final Skill? skill; // Cambiado a Skill? para permitir valores nulos

  Rank({
    required this.id,
    required this.level,
    required this.description,
    required this.skill,
  });

  factory Rank.fromJson(Map<String, dynamic> json) {
    return Rank(
      id: json['id'] is int ? json['id'] as int : 0,
      level: json['level'] is int ? json['level'] as int : 0,
      description: json['description'] as String? ?? 'No description available',
      skill: json['skill'] != null
          ? Skill.fromJson(json['skill'] as Map<String, dynamic>)
          : null, // Ahora 'skill' puede ser nulo
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
