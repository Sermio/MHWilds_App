import 'package:flutter/material.dart';

class SkillContainerPreview extends StatelessWidget {
  final String skillLevel;
  final String skillProgression;

  const SkillContainerPreview({
    super.key,
    required this.skillLevel,
    required this.skillProgression,
  });

  @override
  Widget build(BuildContext context) {
    final progressionList = skillProgression.split(';');

    return Expanded(
      // Agregar Expanded aquí
      child: ListView.builder(
        itemCount: progressionList.length,
        itemBuilder: (context, index) {
          final progression = progressionList[index].trim();
          final levelMatch = RegExp(r'Level (\d+)').firstMatch(progression);
          final level = levelMatch?.group(1);
          final isCurrentLevel = level == skillLevel;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                progression,
                style: TextStyle(
                  fontWeight:
                      isCurrentLevel ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
