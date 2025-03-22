import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/skill_item.dart';
import 'package:mhwilds_app/data/skills.dart';
import 'package:mhwilds_app/models/decoration.dart';
import 'package:mhwilds_app/models/skill.dart';
import 'package:mhwilds_app/utils/overlay_controller.dart'; // Añadir el controlador de overlay
import 'package:mhwilds_app/components/skill_container_preview.dart';
import 'package:mhwilds_app/components/c_preview_container.dart';

class DecorationDetails extends StatefulWidget {
  const DecorationDetails({super.key, required this.decoration});

  final DecorationItem decoration;

  @override
  State<DecorationDetails> createState() => _DecorationDetailsState();
}

class _DecorationDetailsState extends State<DecorationDetails> {
  List<Map<String, dynamic>> cleanedSkillsWithLevel = [];
  final overlayController = OverlayController(); // Instanciar el controlador

  void cleanSkills() {
    String decorationSkills = widget.decoration.decorationSkill;

    List<String> skillList = decorationSkills.split(';');

    cleanedSkillsWithLevel = skillList.map((skill) {
      final RegExp regExp = RegExp(r'(\D+)\s?\+\s?(\d+)');
      final match = regExp.firstMatch(skill);

      if (match != null) {
        String cleanedSkill = match.group(1)!.trim();
        int skillNumber = int.parse(match.group(2)!);
        return {'name': cleanedSkill, 'level': skillNumber};
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
    List<Skill> foundSkills = [];

    for (var cleanedSkill in cleanedSkillsWithLevel) {
      // Asegúrate de que las habilidades están disponibles en el mapa `skills`
      if (skills.containsKey(cleanedSkill['name'])) {
        Skill skill = Skill.fromMap(skills[cleanedSkill['name']]!);
        foundSkills.add(skill);
      }
    }

    List<Skill> filteredSkills = foundSkills.isNotEmpty ? foundSkills : [];

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.decoration.decorationName} details'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      "Decoration Skills",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (filteredSkills.isNotEmpty)
                    Column(
                      children: filteredSkills.map((skill) {
                        final GlobalKey gestureKey = GlobalKey();
                        return SkillItem(
                          skill: skill,
                          gestureKey: gestureKey,
                          onTap: () {
                            // Activar el overlay al hacer clic
                            overlayController.toggleOverlay(
                              skillProgression: skill.progression,
                              skillLevel: skill.levels
                                  .toString(), // Asegúrate de que este campo sea correcto
                              gestureKey: gestureKey,
                            );
                          },
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
          // Mostrar el overlay si está activo
          ValueListenableBuilder<bool>(
            // Escucha los cambios en la visibilidad del overlay
            valueListenable: overlayController.overlayVisible,
            builder: (context, isVisible, child) {
              if (isVisible) {
                return ValueListenableBuilder<Offset>(
                  valueListenable: overlayController.overlayPosition,
                  builder: (context, position, child) {
                    return CcontainerPreview(
                      overlayPortalController:
                          overlayController.overlayPortalController,
                      position: position,
                      content: SkillContainerPreview(
                        skillProgression:
                            overlayController.selectedSkillProgression.value,
                        skillLevel: overlayController.selectedSkillLevel.value,
                      ),
                    );
                  },
                );
              }
              return Container(); // Si no está visible, no se muestra nada
            },
          ),
        ],
      ),
    );
  }
}
