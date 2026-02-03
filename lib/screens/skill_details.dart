import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/url_image_loader.dart';
import 'package:mhwilds_app/providers/skills_provider.dart';
import 'package:mhwilds_app/utils/utils.dart';
import 'package:provider/provider.dart';

class SkillDetails extends StatefulWidget {
  const SkillDetails({super.key, required this.skillsIds, this.skillsLevels});

  final List<int> skillsIds;
  final List<int>? skillsLevels;

  @override
  State<SkillDetails> createState() => _SkillDetailsState();
}

class _SkillDetailsState extends State<SkillDetails> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<SkillsProvider>(context, listen: false);

      if (!provider.hasData) {
        await provider.fetchSkills();
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final skillsProvider = context.watch<SkillsProvider>();

    final filteredSkills = skillsProvider.allSkills
        .where((skill) => widget.skillsIds.contains(skill.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Skill Details'),
        centerTitle: true,
      ),
      body: skillsProvider.isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(
                    'Loading skills...',
                    style: TextStyle(
                      fontSize: 16,
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  ...filteredSkills.asMap().entries.map((entry) {
                    final index = entry.key;
                    final skill = entry.value;

                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.shadow.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Header de la skill
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withOpacity(0.1),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            child: Column(
                              children: [
                                // Imagen de la skill
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: colorScheme.primary
                                            .withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: UrlImageLoader(
                                      itemName: skill.name,
                                      loadImageUrlFunction:
                                          getValidSkillImageUrl,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Nombre de la skill
                                Text(
                                  skill.name,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                // Descripción de la skill
                                if (skill.description.isNotEmpty) ...[
                                  Text(
                                    skill.description,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: colorScheme.onSurface
                                          .withOpacity(0.8),
                                      height: 1.4,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ],
                            ),
                          ),

                          // Sección de rangos
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Skill Ranks:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ...skill.ranks.map((rank) {
                                  bool isCurrentLevel = widget.skillsLevels !=
                                          null &&
                                      index < widget.skillsLevels!.length &&
                                      rank.level == widget.skillsLevels![index];

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: isCurrentLevel
                                          ? colorScheme.primary.withOpacity(0.1)
                                          : colorScheme.surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isCurrentLevel
                                            ? colorScheme.primary
                                                .withOpacity(0.3)
                                            : colorScheme.outlineVariant,
                                        width: isCurrentLevel ? 2 : 1,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: isCurrentLevel
                                                    ? colorScheme.primary
                                                    : colorScheme.onSurface
                                                        .withOpacity(0.4),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                'Level ${rank.level}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: isCurrentLevel
                                                      ? colorScheme.onPrimary
                                                      : colorScheme.surface,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          rank.description,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: colorScheme.onSurface,
                                            height: 1.4,
                                            fontWeight: isCurrentLevel
                                                ? FontWeight.w500
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }
}
