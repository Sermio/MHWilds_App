import 'package:flutter/material.dart';

class SkillContainerPreview extends StatelessWidget {
  final String skillLevel;
  final List<String> skillProgression;

  const SkillContainerPreview({
    super.key,
    required this.skillLevel,
    required this.skillProgression,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: skillProgression.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final progression = skillProgression[index].trim();
        final levelMatch = RegExp(r'Lvl (\d+)').firstMatch(progression);
        final level = levelMatch?.group(1);
        final isCurrentLevel = level == skillLevel;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                progression,
                style: TextStyle(
                  fontWeight:
                      isCurrentLevel ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
