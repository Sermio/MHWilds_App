class Monster {
  final String monsterName;
  final String monsterType;
  final String monsterSpecie;
  final List<String> elements;
  final List<String> ailments;
  final List<String> weaknesses;
  final List<String> resistances;
  final List<String> locations;

  Monster({
    required this.monsterName,
    required this.monsterType,
    required this.monsterSpecie,
    required this.elements,
    required this.ailments,
    required this.weaknesses,
    required this.resistances,
    required this.locations,
  });
}
