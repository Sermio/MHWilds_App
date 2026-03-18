import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/list_filters_panel.dart';
import 'package:mhwilds_app/components/gear_sprite_icon.dart';
import 'package:mhwilds_app/components/skill_sprite_icon.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/skills.dart';
import 'package:mhwilds_app/providers/skills_provider.dart';
import 'package:mhwilds_app/providers/talismans_provider.dart';
import 'package:mhwilds_app/screens/skill_details.dart';
import 'package:provider/provider.dart';
import 'package:mhwilds_app/models/talisman.dart';

class AmuletList extends StatefulWidget {
  const AmuletList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AmuletListState createState() => _AmuletListState();
}

class _AmuletListState extends State<AmuletList> {
  final TextEditingController _searchNameController = TextEditingController();
  String _searchNameQuery = '';
  int? _selectedRarity;
  bool _filtersVisible = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final talismansProvider =
          Provider.of<TalismansProvider>(context, listen: false);
      final skillsProvider = Provider.of<SkillsProvider>(context, listen: false);

      if (!talismansProvider.hasData) {
        talismansProvider.fetchAmulets();
      }
      if (!skillsProvider.hasData && !skillsProvider.isLoading) {
        skillsProvider.fetchSkills();
      }
      _resetFilters();
    });
  }

  void _toggleFiltersVisibility() {
    setState(() {
      _filtersVisible = !_filtersVisible;
    });
  }

  void _resetFilters() {
    setState(() {
      _searchNameQuery = '';
      _selectedRarity = null;
      _searchNameController.clear();
    });
    Provider.of<TalismansProvider>(context, listen: false).clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final talismansProvider = Provider.of<TalismansProvider>(context);
    final skillsProvider = Provider.of<SkillsProvider>(context);
    List<Amulet> filteredAmulets = talismansProvider.filteredAmulets;
    final colorScheme = Theme.of(context).colorScheme;

    if (!talismansProvider.hasData && !talismansProvider.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final p = Provider.of<TalismansProvider>(context, listen: false);
        if (!p.hasData && !p.isLoading) p.fetchAmulets();
      });
    }

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest,
      body: Column(
        children: [
          if (_filtersVisible) _buildFiltersSection(context, talismansProvider),

          // Lista de talismanes
          Expanded(
            child: talismansProvider.isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: colorScheme.primary),
                        const SizedBox(height: 16),
                        Text(
                          l10n.loadingTalismans,
                          style: TextStyle(
                            fontSize: 16,
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  )
                : filteredAmulets.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: colorScheme.onSurface.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.noTalismansFound,
                              style: TextStyle(
                                fontSize: 18,
                                color: colorScheme.onSurface.withOpacity(0.8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.tryAdjustingFilters,
                              style: TextStyle(
                                fontSize: 14,
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        itemCount: filteredAmulets.length,
                        itemBuilder: (context, index) {
                          var amulet = filteredAmulets[index];
                          var ranks = amulet.ranks;
                          var firstRank = ranks.isNotEmpty ? ranks[0] : null;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
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
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  if (firstRank != null) {
                                    final skillIds = firstRank.skills
                                        .map((s) => s.skill.id)
                                        .toList();
                                    final skillLevels = firstRank.skills
                                        .map((s) => s.level)
                                        .toList();

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SkillDetails(
                                          skillsIds: skillIds,
                                          skillsLevels: skillLevels,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Header del talisman
                                      Row(
                                        children: [
                                          // Imagen del talisman
                                          SizedBox(
                                            width: 60,
                                            height: 60,
                                            child: Center(
                                              child: GearSpriteIcon(
                                                column: talismanColumn,
                                                rarity: firstRank?.rarity ?? 0,
                                                size: 42,
                                                fallback: Image.asset(
                                                  'assets/imgs/amulets/rarity${firstRank?.rarity ?? 1}.webp',
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  firstRank?.name ??
                                                      AppLocalizations.of(
                                                              context)!
                                                          .unknown,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color:
                                                        colorScheme.onSurface,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                if (firstRank != null) ...[
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: _getRarityColor(
                                                              firstRank.rarity)
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      border: Border.all(
                                                        color: _getRarityColor(
                                                                firstRank
                                                                    .rarity)
                                                            .withOpacity(0.3),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      l10n.rarityLevel(
                                                          firstRank.rarity),
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: _getRarityColor(
                                                            firstRank.rarity),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: colorScheme.onSurface
                                                .withOpacity(0.5),
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),

                                      // Habilidades del primer rango
                                      if (firstRank != null &&
                                          firstRank.skills.isNotEmpty) ...[
                                        _buildSkillsSection(
                                          firstRank,
                                          skillsProvider,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      // Botón flotante para mostrar/ocultar filtros
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleFiltersVisibility,
        backgroundColor: colorScheme.primary,
        child: Icon(
          _filtersVisible ? Icons.close : Icons.tune,
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }

  Widget _buildFiltersSection(
    BuildContext context,
    TalismansProvider talismansProvider,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return ListFiltersPanel(
      height: 250,
      title: l10n.filters,
      resetLabel: l10n.reset,
      onReset: _resetFilters,
      fields: [
        ListFilterFieldConfig.text(
          id: 'name',
          label: l10n.searchByName,
          controller: _searchNameController,
          onTextChanged: (query) {
            setState(() {
              _searchNameQuery = query;
            });
            _applyFilters(talismansProvider);
          },
          hintText: l10n.enterTalismanName,
          prefixIcon: Icon(Icons.search, color: colorScheme.primary),
        ),
        ListFilterFieldConfig.select(
          id: 'rarity',
          label: l10n.rarity,
          value: _selectedRarity,
          onSelectChanged: (selectedRarity) {
            setState(() {
              _selectedRarity = selectedRarity as int?;
            });
            _applyFilters(talismansProvider);
          },
          options: [1, 2, 3, 4, 5, 6, 7, 8]
              .map(
                (rarity) => ListFilterOption(
                  value: rarity,
                  label: rarity.toString(),
                  leading: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _getRarityColor(rarity),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  void _applyFilters(TalismansProvider talismansProvider) {
    talismansProvider.applyFilters(
      name: _searchNameQuery,
      rarity: _selectedRarity,
    );
  }

  Widget _buildSkillsSection(AmuletRank rank, SkillsProvider skillsProvider) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.flash_on,
              size: 16,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 6),
            Text(
              '${AppLocalizations.of(context)!.skills}:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...rank.skills.map((skill) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colorScheme.primary.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Imagen de la habilidad
                      Container(
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.only(right: 8),
                        child: SkillSpriteIcon(
                          iconId: _skillIconForId(skillsProvider, skill.skill.id)?.id,
                          iconKind:
                              _skillIconForId(skillsProvider, skill.skill.id)?.kind,
                          size: 24,
                          fallback: Icon(
                            Icons.auto_awesome,
                            size: 14,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${skill.skill.name} +${skill.level}',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (skill.description.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      skill.description,
                      style: TextStyle(
                        fontSize: 11,
                        color: colorScheme.onSurface.withOpacity(0.8),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            )),
      ],
    );
  }

  Color _getRarityColor(int rarity) {
    return rarityColorFromSprite(rarity);
  }

  SkillIcon? _skillIconForId(SkillsProvider skillsProvider, int skillId) {
    for (final skill in skillsProvider.allSkills) {
      if (skill.id == skillId) {
        return skill.icon;
      }
    }
    return null;
  }
}
