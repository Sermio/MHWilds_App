class Deco {
  final String name;
  final String type;
  final String rarity;
  final String slot;
  final List<Skill> skills;
  final String description;
  final String meldingCost;

  Deco({
    required this.name,
    required this.type,
    required this.rarity,
    required this.slot,
    required this.skills,
    required this.description,
    required this.meldingCost,
  });

  factory Deco.fromJson(Map<String, dynamic> json) {
    List<String> skillsList = (json["decoration_skill"] as String)
        .split(RegExp(r'\\n|\n'))
        .where((s) => s.isNotEmpty)
        .toList();

    List<Skill> skillObjects = skillsList.expand((skill) {
      return _parseSkills(skill);
    }).toList();

    return Deco(
      name: json["decoration_name"] ?? 'default',
      type: json["decoration_type"] ?? 'default',
      rarity: json["decoration_rarity"] ?? 'default',
      slot: json["decoration_slot"] ?? 'default',
      skills: skillObjects,
      description: json["decoration_description"] ?? 'default',
      meldingCost: json["decoration_melding_cost"] ?? 'default',
    );
  }

  static List<Skill> _parseSkills(String skills) {
    List<Skill> parsedSkills = [];

    List<String> skillList =
        skills.split('\\').where((s) => s.isNotEmpty).toList();

    for (var skill in skillList) {
      int plusIndex = skill.indexOf('+');
      if (plusIndex != -1) {
        String skillName = skill.substring(0, plusIndex).trim();
        int skillLevel = int.parse(skill.substring(plusIndex + 1).trim());
        parsedSkills.add(Skill(skillName: skillName, skillLevel: skillLevel));
      } else {
        parsedSkills.add(Skill(skillName: skill.trim(), skillLevel: 0));
      }
    }

    return parsedSkills;
  }
}

class Skill {
  final String skillName;
  final int skillLevel;

  Skill({required this.skillName, required this.skillLevel});

  @override
  String toString() {
    return '$skillName +$skillLevel';
  }
}
