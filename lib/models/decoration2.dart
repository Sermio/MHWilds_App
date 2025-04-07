class DecorationItem2 {
  final int gameId;
  final Map<String, String> names;
  final Map<String, String> descriptions;
  final int rarity;
  final int price;
  final int level;
  final Map<String, int> skills;
  final String allowedOn;

  DecorationItem2({
    required this.gameId,
    required this.names,
    required this.descriptions,
    required this.rarity,
    required this.price,
    required this.level,
    required this.skills,
    required this.allowedOn,
  });

  factory DecorationItem2.fromJson(Map<String, dynamic> json) {
    return DecorationItem2(
      gameId: json['game_id'],
      names: Map<String, String>.from(json['names']),
      descriptions: Map<String, String>.from(json['descriptions']),
      rarity: json['rarity'],
      price: json['price'],
      level: json['level'],
      skills: Map<String, int>.from(json['skills']),
      allowedOn: json['allowed_on'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'game_id': gameId,
      'names': names,
      'descriptions': descriptions,
      'rarity': rarity,
      'price': price,
      'level': level,
      'skills': skills,
      'allowed_on': allowedOn,
    };
  }
}
