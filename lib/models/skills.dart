// skill2_model.dart

class Skill2 {
  final int gameId;
  final Map<String, String>? names;
  final Map<String, String>? descriptions;
  final List<Rank> ranks;
  final String kind;

  Skill2({
    required this.gameId,
    required this.names,
    required this.descriptions,
    required this.ranks,
    required this.kind,
  });

  factory Skill2.fromJson(Map<String, dynamic> json) {
    return Skill2(
      gameId: json['game_id'] as int,
      names: (json['names'] as Map?)?.map(
        (key, value) => MapEntry(key.toString(), value.toString()),
      ),
      descriptions: (json['descriptions'] as Map?)?.map(
        (key, value) => MapEntry(key.toString(), value.toString()),
      ),
      ranks: (json['ranks'] as List)
          .map((rank) => Rank.fromJson(rank as Map<String, dynamic>))
          .toList(),
      kind: json['kind'] as String,
    );
  }
}

class Rank {
  final int level;
  final Map<String, String> descriptions;
  final String? name; // Por si en algún momento se quiere añadir

  Rank({
    required this.level,
    required this.descriptions,
    this.name,
  });

  factory Rank.fromJson(Map<String, dynamic> json) {
    return Rank(
      level: json['level'] as int,
      descriptions: (json['descriptions'] as Map).map(
        (key, value) => MapEntry(key.toString(), value.toString()),
      ),
      name: json['name'] as String?, // en caso de que exista
    );
  }
}
