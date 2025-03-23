class ArmorPiece {
  final String name;
  final String type;
  final String rarity;
  final String rank;
  final String slots;
  final String armor;
  final String fireResistance;
  final String waterResistance;
  final String thunderResistance;
  final String iceResistance;
  final String dragonResistance;
  final List<String> eqSkills;
  final List<String> groupSkills;
  final List<String> materials;

  ArmorPiece({
    required this.name,
    required this.type,
    required this.rarity,
    required this.rank,
    required this.slots,
    required this.armor,
    required this.fireResistance,
    required this.waterResistance,
    required this.thunderResistance,
    required this.iceResistance,
    required this.dragonResistance,
    required this.eqSkills,
    required this.groupSkills,
    required this.materials,
  });

  factory ArmorPiece.fromJson(Map<String, dynamic> json) {
    return ArmorPiece(
      name: json["name"],
      type: json["type"],
      rarity: json["rarity"],
      rank: json["rank"],
      slots: json["slots"],
      armor: json["armor"],
      fireResistance: json["fire_resistance"],
      waterResistance: json["water_resistance"],
      thunderResistance: json["thunder_resistance"],
      iceResistance: json["ice_resistance"],
      dragonResistance: json["dragon_resistance"],
      eqSkills: (json["eq_skills"] as String)
          .split("\n")
          .where((s) => s.isNotEmpty)
          .toList(),
      groupSkills: (json["group_skills"] as String)
          .split("\n")
          .where((s) => s.isNotEmpty)
          .toList(),
      materials: (json["materials"] as String)
          .split("\n")
          .where((s) => s.isNotEmpty)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "type": type,
      "rarity": rarity.toString(),
      "rank": rank,
      "slots": slots,
      "armor": armor.toString(),
      "fire_resistance": fireResistance.toString(),
      "water_resistance": waterResistance.toString(),
      "thunder_resistance": thunderResistance.toString(),
      "ice_resistance": iceResistance.toString(),
      "dragon_resistance": dragonResistance.toString(),
      "eq_skills": eqSkills.join("\n"),
      "group_skills": groupSkills.join("\n"),
      "materials": materials.join("\n"),
    };
  }
}
