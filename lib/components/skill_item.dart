import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/url_image_loader.dart';
import 'package:mhwilds_app/models/armor_set.dart';
import 'package:mhwilds_app/providers/en_names_cache.dart';
import 'package:mhwilds_app/utils/utils.dart';
import 'package:provider/provider.dart';

class SkillItem extends StatelessWidget {
  final Skill skill;
  final int skillNumber;

  const SkillItem({
    super.key,
    required this.skill,
    required this.skillNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          // showDialog(
          //   context: context,
          //   builder: (context) => AlertDialog(
          //     content: SizedBox(
          //       width: double.maxFinite,
          //       child: ConstrainedBox(
          //         constraints: const BoxConstraints(maxHeight: 300),
          //         child: SkillContainerPreview(
          //           skillLevel: skillNumber.toString(),
          //           skillProgression: skill.progression,
          //         ),
          //       ),
          //     ),
          //   ),
          // );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: GestureDetector(
                child: UrlImageLoader(
                  animate: true,
                  itemName: Provider.of<EnNamesCache>(context, listen: false)
                          .nameForSkillImage(skill.id, skill.name) ??
                      skill.name,
                  loadImageUrlFunction: getValidSkillImageUrl,
                ),
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${skill.name} + $skillNumber",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Text(
                  //   skill.description,
                  //   style: const TextStyle(fontSize: 15),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
