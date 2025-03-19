class Monster {
  final String monsterName;
  final String monsterType;
  final String monsterSpecie;
  final List<String> element;
  final List<String> ailment;
  final List<String> weaknesses;
  final List<String> resistances;
  final List<String> locations;

  Monster({
    required this.monsterName,
    required this.monsterType,
    required this.monsterSpecie,
    required this.element,
    required this.ailment,
    required this.weaknesses,
    required this.resistances,
    required this.locations,
  });
}
