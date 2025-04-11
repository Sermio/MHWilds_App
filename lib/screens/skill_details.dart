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
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredSkills.length,
              itemBuilder: (context, index) {
                final skill = filteredSkills[index];
                return Column(
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: UrlImageLoader(
                        itemName: skill.name,
                        loadImageUrlFunction: getValidSkillImageUrl,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      skill.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(skill.description),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...skill.ranks.map(
                              (rank) => Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Lv ${rank.level}: ",
                                    style: widget.skillsLevels != null &&
                                            index <
                                                widget.skillsLevels!.length &&
                                            rank.level ==
                                                widget.skillsLevels![index]
                                        ? const TextStyle(
                                            fontWeight: FontWeight.bold)
                                        : const TextStyle(),
                                  ),
                                  Expanded(child: Text(rank.description)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                );
              },
            ),
    );
  }
}
