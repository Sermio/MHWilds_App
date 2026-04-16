import 'package:mhwilds_app/models/armor_piece.dart';

class ArmorSet {
  final String name;
  final List<ArmorPiece> pieces;
  final Bonus setBonusSkill;
  final GroupBonus groupBonusSkill;
  final int id;
  final int gameId;

  ArmorSet({
    required this.name,
    required this.pieces,
    required this.setBonusSkill,
    required this.groupBonusSkill,
    required this.id,
    required this.gameId,
  });

  factory ArmorSet.fromJson(Map<String, dynamic> json) {
    dynamic rawBonus = json['setBonusSkill'] ??
        json['set_bonus_skill'] ??
        json['bonus'] ??
        json['setBonus'] ??
        json['set_bonus'];

    dynamic rawGroupBonus = json['groupBonusSkill'] ??
        json['group_bonus_skill'] ??
        json['groupBonus'] ??
        json['group_bonus'] ??
        json['groupbonus'];

    // Robustez: si la API envía un ID numérico directamente
    if (rawBonus is int) {
      rawBonus = {'id': rawBonus};
    }
    if (rawGroupBonus is int) {
      rawGroupBonus = {'id': rawGroupBonus};
    }

    return ArmorSet(
      name: json['name'] as String? ?? '',
      pieces: (json['pieces'] as List? ?? [])
          .map((piece) => ArmorPiece.fromJson(piece))
          .toList(),
      setBonusSkill: Bonus.fromJson(rawBonus is Map
          ? Map<String, dynamic>.from(rawBonus)
          : (rawBonus is int ? {'id': rawBonus} : {})),
      groupBonusSkill: GroupBonus.fromJson(rawGroupBonus is Map
          ? Map<String, dynamic>.from(rawGroupBonus)
          : {}),
      id: json['id'] as int? ?? 0,
      gameId: json['gameId'] as int? ?? (json['game_id'] as int? ?? 0),
    );
  }
}

class Bonus {
  final int id;
  final String name;

  Bonus({
    required this.id,
    required this.name,
  });

  factory Bonus.fromJson(Map<String, dynamic> json) {
    final skillId = json['skillId'] ?? json['skill_id'];
    return Bonus(
      id: json['id'] as int? ?? (skillId as int? ?? 0),
      name: json['name'] as String? ?? '',
    );
  }
}

class GroupBonus {
  final int id;
  final String name;
  final Skill skill;
  final List<Rank> ranks;

  GroupBonus({
    required this.id,
    required this.name,
    required this.skill,
    required this.ranks,
  });

  factory GroupBonus.fromJson(Map<String, dynamic> json) {
    return GroupBonus(
      id: json['id'] as int? ??
          (json['groupBonusId'] as int? ??
              (json['group_bonus_id'] as int? ?? 0)),
      name: json['name'] as String? ?? (json['skill']?['name'] as String? ?? ''),
      skill: Skill.fromJson(json['skill'] ?? {}),
      ranks: (json['ranks'] as List? ?? [])
          .map((rankJson) => Rank.fromJson(rankJson))
          .toList(),
    );
  }
}

class Skill {
  final int id;
  final String name;

  Skill({
    required this.id,
    required this.name,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
    );
  }
}

class Rank {
  final Bonus bonus;
  final int pieces;
  final SkillWithLevel skill;
  final int id;
  final String name;
  final String description;
  final int level;

  Rank({
    required this.bonus,
    required this.pieces,
    required this.skill,
    required this.id,
    required this.name,
    required this.description,
    required this.level,
  });

  factory Rank.fromJson(Map<String, dynamic> json) {
    final rawBonus = json['setBonusSkill'] ??
        json['set_bonus_skill'] ??
        json['bonus'] ??
        json['setBonus'] ??
        json['set_bonus'];

    return Rank(
      bonus: Bonus.fromJson(rawBonus is Map
          ? Map<String, dynamic>.from(rawBonus)
          : (rawBonus is int ? {'id': rawBonus} : {})),
      pieces: json['pieces'] as int? ??
          (json['set_pieces_required'] as int? ??
              (json['setPiecesRequired'] as int? ?? 0)),
      skill: SkillWithLevel.fromJson(json),
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      level: json['level'] as int? ?? 0,
    );
  }
}

class SkillWithLevel {
  final int id;
  final Skill skill;
  final int level;
  final String description;

  SkillWithLevel({
    required this.id,
    required this.skill,
    required this.level,
    required this.description,
  });

  factory SkillWithLevel.fromJson(Map<String, dynamic> json) {
    return SkillWithLevel(
      id: json['id'] as int? ?? 0,
      skill: Skill.fromJson(json['skill'] ?? {}),
      level: json['level'] as int? ??
          (json['rank'] as int? ?? (json['skillLevel'] as int? ?? 0)),
      description: json['description'] as String? ??
          (json['skill']?['description'] as String? ?? ''),
    );
  }
}
