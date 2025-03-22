import 'package:flutter/material.dart';

class OverlayController {
  final OverlayPortalController overlayPortalController;
  final ValueNotifier<bool> overlayVisible;
  final ValueNotifier<Offset> overlayPosition;
  final ValueNotifier<String> selectedSkillProgression;
  final ValueNotifier<String> selectedSkillLevel;

  OverlayController()
      : overlayPortalController = OverlayPortalController(),
        overlayVisible = ValueNotifier<bool>(false),
        overlayPosition = ValueNotifier<Offset>(Offset.zero),
        selectedSkillProgression = ValueNotifier<String>("1"),
        selectedSkillLevel = ValueNotifier<String>("1");

  void toggleOverlay({
    required String skillLevel, // Usamos skillLevel en lugar de skillId
    required String
        skillProgression, // Usamos skillProgression en lugar de skillId
    required GlobalKey gestureKey,
  }) {
    if (gestureKey.currentContext != null) {
      final renderBox =
          gestureKey.currentContext!.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;

      overlayPosition.value = Offset(
        position.dx + size.width,
        position.dy + size.height,
      );

      selectedSkillProgression.value =
          skillProgression; // Establecemos skillProgression
      selectedSkillLevel.value = skillLevel; // Establecemos skillLevel
      overlayVisible.value = !overlayVisible.value;

      if (overlayVisible.value) {
        overlayPortalController.show();
      } else {
        overlayPortalController.hide();
      }
    }
  }
}
