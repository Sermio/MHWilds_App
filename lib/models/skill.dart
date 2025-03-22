class Skill {
  final String name;
  final String type;
  final String description;
  final String progression;
  final String levels;

  Skill({
    required this.name,
    required this.type,
    required this.description,
    required this.progression,
    required this.levels,
  });

  factory Skill.fromMap(Map<String, dynamic> map) {
    return Skill(
      name: map['name'] ?? 'Unknown',
      type: map['type'] ?? 'Unknown',
      description: map['description'] ?? 'Unknown',
      progression: map['progression'] ?? 'Unknown',
      levels: map['levels'] ?? 'Unknown',
    );
  }
}
