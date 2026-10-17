import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/skills.dart';
import 'package:mhwilds_app/models/weapon.dart';
import 'package:mhwilds_app/providers/skills_provider.dart';
import 'package:mhwilds_app/providers/weapons_provider.dart';
import 'package:mhwilds_app/screens/weapon_details/crafting_costs.dart';
import 'package:mhwilds_app/screens/weapon_details/crafting_modal.dart';
import 'package:mhwilds_app/screens/weapon_details/weapon_crafting_section.dart';
import 'package:mhwilds_app/screens/weapon_details/weapon_header.dart';
import 'package:mhwilds_app/screens/weapon_details/weapon_sharpness_section.dart';
import 'package:mhwilds_app/screens/weapon_details/weapon_skills_section.dart';
import 'package:mhwilds_app/screens/weapon_details/weapon_stats_section.dart';
import 'package:mhwilds_app/screens/weapon_details/weapon_tree_section.dart';
import 'package:mhwilds_app/utils/weapon_tree_builder.dart';
import 'package:provider/provider.dart';

class WeaponDetails extends StatefulWidget {
  final Weapon weapon;

  const WeaponDetails({super.key, required this.weapon});

  @override
  State<WeaponDetails> createState() => _WeaponDetailsState();
}

class _WeaponDetailsState extends State<WeaponDetails> {
  late Future<List<Skills>> _skills;
  bool _isTreeView = true;

  @override
  void initState() {
    super.initState();
    _skills = fetchSkillsForWeapon(widget.weapon);
  }

  Future<List<Skills>> fetchSkillsForWeapon(Weapon weapon) => context
      .read<SkillsProvider>()
      .skillsByIds(weapon.skills.map((s) => s.skill.id).toSet());

  @override
  Widget build(BuildContext context) {
    final weapon = widget.weapon;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest,
      appBar: AppBar(
        title: Text(weapon.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            WeaponHeader(weapon: weapon),
            WeaponStatsSection(weapon: weapon),
            if (hasSharpnessData(weapon.sharpness))
              WeaponSharpnessSection(sharpness: weapon.sharpness),
            if (weapon.skills.isNotEmpty)
              WeaponSkillsSection(
                skills: _skills,
                weaponSkills: weapon.skills,
              ),
            if (_hasWeaponTreeData()) _buildWeaponTreeSection(),
            if (hasCraftingData(weapon.crafting))
              WeaponCraftingSection(crafting: weapon.crafting),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  bool _hasWeaponTreeData() {
    return widget.weapon.crafting.previous != null ||
        widget.weapon.crafting.branches.isNotEmpty;
  }

  Widget _buildWeaponTreeSection() {
    final provider = Provider.of<WeaponsProvider>(context, listen: false);
    final rootNode = WeaponTreeBuilder.buildTree(widget.weapon, provider);
    if (rootNode == null) return const SizedBox.shrink();

    return WeaponTreeSection(
      rootNode: rootNode,
      currentWeaponId: widget.weapon.id,
      isTreeView: _isTreeView,
      onViewChanged: (isTree) => setState(() => _isTreeView = isTree),
      onOpenWeapon: _navigateToWeaponById,
      onShowCrafting: (w) => showWeaponCraftingModal(context, w),
    );
  }

  void _navigateToWeaponById(int id) async {
    try {
      unawaited(showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      ));
      final weapon = await context.read<WeaponsProvider>().weaponById(id);
      if (mounted) {
        Navigator.pop(context); // close dialog
        unawaited(Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WeaponDetails(weapon: weapon),
          ),
        ));
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // close dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  AppLocalizations.of(context)?.errorLoadingWeaponDetails ??
                      'Error loading weapon details')),
        );
      }
    }
  }
}
