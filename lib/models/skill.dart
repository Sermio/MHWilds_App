class Skill {
  final String name;
  final String type;
  final String description;
  final List<String> progression;
  final String levels;

  Skill({
    required this.name,
    required this.type,
    required this.description,
    required this.progression,
    required this.levels,
  });

  factory Skill.fromMap(Map<String, dynamic> json) {
    return Skill(
      name: json["name"],
      type: json["type"],
      description: json["description"],
      progression: (json["progression"] as String)
          .split(";")
          .map((e) => e.trim())
          .toList(),
      levels: json["levels"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "type": type,
      "description": description,
      "progression": progression.join(" ;"),
      "levels": levels,
    };
  }
}

class SkillSet {
  final Map<String, Skill> skills;

  SkillSet({required this.skills});

  factory SkillSet.fromJson(Map<String, Map<String, dynamic>> json) {
    return SkillSet(
      skills: json.map((key, value) => MapEntry(key, Skill.fromMap(value))),
    );
  }

  Map<String, Map<String, dynamic>> toJson() {
    return skills.map((key, value) => MapEntry(key, value.toJson()));
  }
}
