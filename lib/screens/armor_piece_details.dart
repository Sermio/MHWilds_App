import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/app_bar_background.dart';
import 'package:mhwilds_app/models/armor_piece.dart' as armor_models;
import 'package:mhwilds_app/models/skills.dart';
import 'package:mhwilds_app/providers/skills_provider.dart';
import 'package:mhwilds_app/screens/armor_piece_details/armor_crafting_section.dart';
import 'package:mhwilds_app/screens/armor_piece_details/armor_header.dart';
import 'package:mhwilds_app/screens/armor_piece_details/armor_skills_section.dart';
import 'package:mhwilds_app/screens/armor_piece_details/armor_stats_section.dart';
import 'package:provider/provider.dart';

export 'package:mhwilds_app/screens/armor_piece_details/armor_base_defense.dart';
export 'package:mhwilds_app/screens/armor_piece_details/armor_piece_slots_widget.dart';
export 'package:mhwilds_app/screens/armor_piece_details/armor_resistances_widget.dart';

class ArmorDetails extends StatefulWidget {
  final armor_models.ArmorPiece armor;

  const ArmorDetails({super.key, required this.armor});

  @override
  State<ArmorDetails> createState() => _ArmorDetailsState();
}

class _ArmorDetailsState extends State<ArmorDetails> {
  late Future<List<Skills>> _skills;

  @override
  void initState() {
    super.initState();
    _skills = context
        .read<SkillsProvider>()
        .skillsByIds(widget.armor.skills.map((s) => s.skill.id).toSet());
  }

  @override
  Widget build(BuildContext context) {
    final armor = widget.armor;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const AppBarBackground(),
        title: Text(armor.name),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ArmorHeader(armor: armor),
            ArmorStatsSection(armor: armor),
            ArmorSkillsSection(armor: armor, skills: _skills),
            if (armorHasCraftingData(armor)) ArmorCraftingSection(armor: armor),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
