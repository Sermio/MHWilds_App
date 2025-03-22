// skill_item.dart

import 'package:flutter/material.dart';

class SkillItem extends StatelessWidget {
  // final Skill skill;
  final GlobalKey gestureKey;
  final VoidCallback onTap;

  const SkillItem({
    super.key,
    // required this.skill,
    required this.gestureKey,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: GestureDetector(
              key: gestureKey,
              onTap: onTap,
              // child: UrlImageLoader(
              //   itemName: skill.skillName,
              //   loadImageUrlFunction: getValidDecorationImageUrl,
              // ),
            ),
          ),
          const SizedBox(width: 18),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   "${skill.skillName} + ${skill.level}",
                //   style: const TextStyle(
                //     fontSize: 13,
                //     fontWeight: FontWeight.bold,
                //   ),
                //   overflow: TextOverflow.ellipsis,
                // ),
                // Text(
                //   skill.description,
                //   style: const TextStyle(fontSize: 16),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
