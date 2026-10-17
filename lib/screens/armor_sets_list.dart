import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/filter_panel_layout.dart';
import 'package:mhwilds_app/components/async_list_body.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/armor_set.dart' as set_models;
import 'package:mhwilds_app/models/skills.dart' as skills_model;
import 'package:mhwilds_app/providers/armor_sets_provider.dart';
import 'package:mhwilds_app/providers/skills_provider.dart';
import 'package:mhwilds_app/screens/armor_sets_list/armor_piece_card.dart';
import 'package:mhwilds_app/screens/armor_sets_list/armor_set_bonus_section.dart';
import 'package:mhwilds_app/screens/armor_sets_list/armor_set_filters.dart';
import 'package:mhwilds_app/utils/spacing.dart';
import 'package:provider/provider.dart';

export 'package:mhwilds_app/screens/armor_sets_list/armor_set_bonus_section.dart'
    show ArmorSetBonusSection;

class ArmorSetList extends StatefulWidget {
  const ArmorSetList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ArmorSetListState createState() => _ArmorSetListState();
}

class _ArmorSetListState extends State<ArmorSetList> {
  // El filtro vive en ArmorSetProvider; aquí solo el controlador del texto.
  late final TextEditingController _searchNameController;
  bool _filtersVisible = false;

  @override
  void initState() {
    super.initState();
    _searchNameController = TextEditingController(
        text: context.read<ArmorSetProvider>().filter.name);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final armorSetProvider =
          Provider.of<ArmorSetProvider>(context, listen: false);
      final skillsProvider =
          Provider.of<SkillsProvider>(context, listen: false);

      if (!armorSetProvider.hasData) {
        armorSetProvider.fetchArmorSets();
      }
      if (!skillsProvider.hasData && !skillsProvider.isLoading) {
        skillsProvider.fetchSkills();
      }
    });
  }

  void _toggleFiltersVisibility() {
    setState(() {
      _filtersVisible = !_filtersVisible;
    });
  }

  void _resetFilters() {
    _searchNameController.clear();
    context.read<ArmorSetProvider>().clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final armorSetProvider = Provider.of<ArmorSetProvider>(context);
    final filteredArmorSets = armorSetProvider.armorSets;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest,
      body: FilterPanelLayout(
        panel: !_filtersVisible
            ? null
            : ArmorSetFiltersPanel(
                filter: armorSetProvider.filter,
                nameController: _searchNameController,
                onFilterChanged: armorSetProvider.setFilter,
                onReset: _resetFilters,
              ),
        child: Stack(
          children: [
            AsyncListBody<set_models.ArmorSet>(
              state: armorSetProvider.state,
              isOffline: armorSetProvider.isOffline,
              loadingLabel: l10n.loadingArmorSets,
              emptyTitle: l10n.noArmorSetsFound,
              emptySubtitle: l10n.tryAdjustingFilters,
              onRetry: armorSetProvider.fetchArmorSets,
              onRefresh: () => armorSetProvider.refresh(force: true),
              isEmpty: (_) => filteredArmorSets.isEmpty,
              builder: (context, _) => ListView.builder(
                key: const PageStorageKey('armor-sets-list'),
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 120, top: AppSpacing.lg),
                itemCount: filteredArmorSets.length,
                itemBuilder: (context, index) =>
                    _buildArmorSet(context, filteredArmorSets[index]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: _filtersVisible ? l10n.close : l10n.filters,
        onPressed: _toggleFiltersVisibility,
        backgroundColor: colorScheme.primary,
        child: Icon(
          _filtersVisible ? Icons.close : Icons.tune,
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }

  Widget _buildArmorSet(BuildContext context, set_models.ArmorSet armorSet) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasBonus = armorSet.groupBonusSkill.ranks.isNotEmpty ||
        armorSet.pieces.any((p) => p.skills.any((s) => s.isSetOrGroupBonus));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
          child: Text(
            armorSet.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        if (hasBonus)
          ArmorSetBonusSection(
            armorSet: armorSet,
            onSkillIconRequest: (id) => _skillIconForId(id, context),
          ),
        ...armorSet.pieces.map(
          (piece) => ArmorPieceCard(
            piece: piece,
            onSkillIconRequest: (id) => _skillIconForId(id, context),
          ),
        ),
      ],
    );
  }

  skills_model.SkillIcon? _skillIconForId(int skillId, BuildContext context) {
    final skillsProvider = Provider.of<SkillsProvider>(context, listen: false);
    for (final skill in skillsProvider.allSkills) {
      if (skill.id == skillId) {
        return skill.icon;
      }
    }
    return null;
  }
}
