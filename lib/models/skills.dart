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
    final namesMap = json['names'];
    final descriptionsMap = json['descriptions'];
    String nameFromNames = '';
    String descriptionFromDescriptions = '';
    if (namesMap is Map) {
      nameFromNames = (namesMap['en'] ?? namesMap['es'] ?? '').toString();
    }
    if (descriptionsMap is Map) {
      descriptionFromDescriptions =
          (descriptionsMap['en'] ?? descriptionsMap['es'] ?? '').toString();
    }

    return Skills(
      id: json['id'] is int ? json['id'] as int : 0,
      gameId: json['gameId'] is int
          ? json['gameId'] as int
          : (json['game_id'] is int ? json['game_id'] as int : 0),
      name: (json['name'] as String?)?.trim().isNotEmpty == true
          ? (json['name'] as String).trim()
          : (nameFromNames.isNotEmpty ? nameFromNames : 'Unknown'),
      kind: json['kind'] as String? ?? 'Unknown',
      description: (json['description'] as String?)?.trim().isNotEmpty == true
          ? (json['description'] as String).trim()
          : (descriptionFromDescriptions.isNotEmpty
              ? descriptionFromDescriptions
              : 'No description available'),
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
  final int setPiecesRequired;

  Rank({
    required this.id,
    required this.level,
    required this.description,
    required this.skill,
    this.setPiecesRequired = 0,
  });

  factory Rank.fromJson(Map<String, dynamic> json) {
    final descriptionsMap = json['descriptions'];
    String descriptionFromDescriptions = '';
    if (descriptionsMap is Map) {
      descriptionFromDescriptions =
          (descriptionsMap['en'] ?? descriptionsMap['es'] ?? '').toString();
    }

    return Rank(
      id: json['id'] is int ? json['id'] as int : 0,
      level: json['level'] is int ? json['level'] as int : 0,
      description: (json['description'] as String?)?.trim().isNotEmpty == true
          ? (json['description'] as String).trim()
          : (descriptionFromDescriptions.isNotEmpty
              ? descriptionFromDescriptions
              : 'No description available'),
      skill: json['skill'] != null
          ? Skill.fromJson(json['skill'] as Map<String, dynamic>)
          : null, // Ahora 'skill' puede ser nulo
      setPiecesRequired: json['set_pieces_required'] is int
          ? json['set_pieces_required'] as int
          : (json['setPiecesRequired'] is int
              ? json['setPiecesRequired'] as int
              : 0),
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
