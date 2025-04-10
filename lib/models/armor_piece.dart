class ArmorPiece {
  final int gameId;
  final Map<String, String> names;
  final int rarity;
  final dynamic setBonus;
  final GroupBonus groupBonus;
  final List<Piece> pieces;

  ArmorPiece({
    required this.gameId,
    required this.names,
    required this.rarity,
    this.setBonus,
    required this.groupBonus,
    required this.pieces,
  });

  factory ArmorPiece.fromJson(Map<String, dynamic> json) {
    return ArmorPiece(
      gameId: json['game_id'],
      names: Map<String, String>.from(json['names']),
      rarity: json['rarity'],
      setBonus: json['set_bonus'],
      groupBonus: GroupBonus.fromJson(json['group_bonus']),
      pieces: (json['pieces'] as List)
          .map((piece) => Piece.fromJson(piece))
          .toList(),
    );
  }
}

class GroupBonus {
  final int skillId;
  final List<Rank> ranks;

  GroupBonus({
    required this.skillId,
    required this.ranks,
  });

  factory GroupBonus.fromJson(Map<String, dynamic> json) {
    return GroupBonus(
      skillId: json['skill_id'],
      ranks:
          (json['ranks'] as List).map((rank) => Rank.fromJson(rank)).toList(),
    );
  }
}

class Rank {
  final int pieces;
  final int skillLevel;

  Rank({
    required this.pieces,
    required this.skillLevel,
  });

  factory Rank.fromJson(Map<String, dynamic> json) {
    return Rank(
      pieces: json['pieces'],
      skillLevel: json['skill_level'],
    );
  }
}

class Piece {
  final String kind;
  final Map<String, String> names;
  final Map<String, String> descriptions;
  final Defense defense;
  final Resistances resistances;
  final List<int> slots;
  final Map<String, int> skills;
  final Crafting crafting;

  Piece({
    required this.kind,
    required this.names,
    required this.descriptions,
    required this.defense,
    required this.resistances,
    required this.slots,
    required this.skills,
    required this.crafting,
  });

  factory Piece.fromJson(Map<String, dynamic> json) {
    return Piece(
      kind: json['kind'],
      names: Map<String, String>.from(json['names']),
      descriptions: Map<String, String>.from(json['descriptions']),
      defense: Defense.fromJson(json['defense']),
      resistances: Resistances.fromJson(json['resistances']),
      slots: List<int>.from(json['slots']),
      skills: Map<String, int>.from(json['skills']),
      crafting: Crafting.fromJson(json['crafting']),
    );
  }
}

class Defense {
  final int base;
  final int max;

  Defense({
    required this.base,
    required this.max,
  });

  factory Defense.fromJson(Map<String, dynamic> json) {
    return Defense(
      base: json['base'],
      max: json['max'],
    );
  }
}

class Resistances {
  final int fire;
  final int water;
  final int thunder;
  final int ice;
  final int dragon;

  Resistances({
    required this.fire,
    required this.water,
    required this.thunder,
    required this.ice,
    required this.dragon,
  });

  factory Resistances.fromJson(Map<String, dynamic> json) {
    return Resistances(
      fire: json['fire'],
      water: json['water'],
      thunder: json['thunder'],
      ice: json['ice'],
      dragon: json['dragon'],
    );
  }
}

class Crafting {
  final int price;
  final Map<String, int> inputs;

  Crafting({
    required this.price,
    required this.inputs,
  });

  factory Crafting.fromJson(Map<String, dynamic> json) {
    return Crafting(
      price: json['price'],
      inputs: Map<String, int>.from(json['inputs']),
    );
  }
}
