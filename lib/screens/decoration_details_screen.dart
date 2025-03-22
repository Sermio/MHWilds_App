// decoration_details.dart

import 'package:flutter/material.dart';
import 'package:mhwilds_app/models/decoration.dart';

class DecorationDetails extends StatelessWidget {
  const DecorationDetails({super.key, required this.decoration});

  final DecorationItem decoration;

  @override
  Widget build(BuildContext context) {
    // final overlayController = OverlayController();

    return Scaffold(
      appBar: AppBar(
        title: Text('${decoration.decorationName} details'),
      ),
      body: const Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Decoration Skills",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // if (decoration.skills.isNotEmpty) ...[
                  //   Column(
                  //     children: decoration.skills.map((skill) {
                  //       final GlobalKey gestureKey = GlobalKey();
                  //       return const SizedBox();
                  //       // SkillItem(
                  //       //   skill: skill,
                  //       //   gestureKey: gestureKey,
                  //       //   onTap: () {
                  //       //     overlayController.toggleOverlay(
                  //       //       skillId: skill.skillId,
                  //       //       skillLevel: skill.level,
                  //       //       gestureKey: gestureKey,
                  //       //     );
                  //       //   },
                  //       // );
                  //     }).toList(),
                  //   ),
                  // ] else ...[
                  //   const Text("No skills available"),
                  // ],
                  SizedBox(height: 80),
                ],
              ),
            ),
          ),
          // ValueListenableBuilder<bool>(
          //   valueListenable: overlayController.overlayVisible,
          //   builder: (context, isVisible, child) {
          //     if (isVisible) {
          //       return ValueListenableBuilder<Offset>(
          //         valueListenable: overlayController.overlayPosition,
          //         builder: (context, position, child) {
          //           return CcontainerPreview(
          //             overlayPortalController:
          //                 overlayController.overlayPortalController,
          //             position: position,
          //             content: SkillContainerPreview(
          //               skillId: overlayController.selectedSkillId.value,
          //               skillLevel: overlayController.selectedSkillLevel.value,
          //             ),
          //           );
          //         },
          //       );
          //     }
          //     return Container();
          //   },
          // ),
        ],
      ),
    );
  }
}
