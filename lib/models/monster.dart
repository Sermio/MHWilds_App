class Monster {
  final String monsterName;
  final String monsterSpecie;
  final List<String>? locations;
  final String monsterType;
  final List<String> elements;
  final List<String> ailments;
  final List<String> weaknesses;
  final List<String> resistances;

  Monster({
    required this.monsterName,
    required this.monsterSpecie,
    this.locations,
    required this.monsterType,
    required this.elements,
    required this.ailments,
    required this.weaknesses,
    required this.resistances,
  });

  factory Monster.fromMap(Map<String, dynamic> map) {
    return Monster(
      monsterName: map['monsterName'] ?? '',
      monsterSpecie: map['monsterSpecie'] ?? '',
      locations: List<String>.from(map['locations'] ?? []),
      monsterType: map['monsterType'] ?? '',
      elements: List<String>.from(map['elements'] ?? []),
      ailments: List<String>.from(map['ailments'] ?? []),
      weaknesses: List<String>.from(map['weaknesses'] ?? []),
      resistances: List<String>.from(map['resistances'] ?? []),
    );
  }
}
