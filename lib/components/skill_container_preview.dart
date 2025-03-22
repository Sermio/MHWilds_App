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

    return ListView.separated(
      shrinkWrap: true, // Se ajusta al contenido
      physics:
          const NeverScrollableScrollPhysics(), // Desactiva el desplazamiento interno
      itemCount: progressionList.length,
      separatorBuilder: (context, index) =>
          const Divider(), // Separador entre elementos
      itemBuilder: (context, index) {
        final progression = progressionList[index].trim();
        final levelMatch = RegExp(r'Level (\d+)').firstMatch(progression);
        final level = levelMatch?.group(1);
        final isCurrentLevel = level == skillLevel;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                progression,
                style: TextStyle(
                  fontWeight: progression.contains('Lvl $skillLevel')
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
