import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/skill_item.dart';
import 'package:mhwilds_app/data/skills.dart';
import 'package:mhwilds_app/models/decoration.dart';
import 'package:mhwilds_app/models/skill.dart';
import 'package:mhwilds_app/utils/overlay_controller.dart';

class DecorationDetails extends StatefulWidget {
  const DecorationDetails({super.key, required this.decoration});

  final DecorationItem decoration;

  @override
  State<DecorationDetails> createState() => _DecorationDetailsState();
}

class _DecorationDetailsState extends State<DecorationDetails> {
  List<Map<String, dynamic>> cleanedSkillsWithLevel = [];
  final overlayController = OverlayController();

  void cleanSkills() {
    String decorationSkills = widget.decoration.decorationSkill;
    List<String> skillList = decorationSkills.split(';');

    cleanedSkillsWithLevel = skillList.map((skill) {
      final RegExp regExp = RegExp(r'(\D+)\s?\+\s?(\d+)');
      final match = regExp.firstMatch(skill);

      if (match != null) {
        return {
          'name': match.group(1)!.trim(),
          'level': int.parse(match.group(2)!),
        };
      }
      return {'name': skill, 'level': 0};
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    cleanSkills();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> foundSkills = [];

    for (var cleanedSkill in cleanedSkillsWithLevel) {
      if (skills.containsKey(cleanedSkill['name'])) {
        Skill skill = Skill.fromMap(skills[cleanedSkill['name']]!);
        foundSkills.add({
          "skill": skill,
          "level": cleanedSkill["level"],
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.decoration.decorationName),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  if (foundSkills.isNotEmpty)
                    Column(
                      children: foundSkills.map((skillData) {
                        return SkillItem(
                          skill: skillData["skill"],
                          skillNumber: skillData["level"],
                        );
                      }).toList(),
                    )
                  else
                    const Text("No skills available"),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
