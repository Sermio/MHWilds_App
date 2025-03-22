// preview_container_elements.dart

import 'package:flutter/material.dart';

class SkillContainerPreview extends StatelessWidget {
  final int skillId;
  final int skillLevel;

  const SkillContainerPreview({
    super.key,
    required this.skillId,
    required this.skillLevel,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
    // return FutureBuilder<SpecificSkill>(
    //   future: GetDecorationsList.fetchDecorationSkill(skillId),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const Center(child: CircularProgressIndicator());
    //     } else if (snapshot.hasError) {
    //       return Center(child: Text("Error: ${snapshot.error}"));
    //     } else if (snapshot.hasData) {
    //       final skill = snapshot.data!;
    //       return ListView.separated(
    //         shrinkWrap: true,
    //         physics: const NeverScrollableScrollPhysics(),
    //         itemCount: skill.ranks.length,
    //         separatorBuilder: (context, index) => const Divider(),
    //         itemBuilder: (context, index) {
    //           final rank = skill.ranks[index];
    //           return Row(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 "Lvl ${rank.level}: ",
    //                 style: TextStyle(
    //                   fontSize: 18,
    //                   fontWeight: rank.level == skillLevel
    //                       ? FontWeight.bold
    //                       : FontWeight.normal,
    //                 ),
    //               ),
    //               const SizedBox(width: 10),
    //               Expanded(
    //                 child: Text(
    //                   rank.description,
    //                   style: const TextStyle(fontSize: 14),
    //                 ),
    //               ),
    //             ],
    //           );
    //         },
    //       );
    //     }
    //     return Container();
    //   },
    // );
  }
}
