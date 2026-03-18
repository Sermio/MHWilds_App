import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/gear_sprite_icon.dart';
import 'package:mhwilds_app/components/list_filters_panel.dart';
import 'package:mhwilds_app/components/skill_sprite_icon.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/screens/skill_details.dart';
import 'package:provider/provider.dart';
import 'package:mhwilds_app/providers/skills_provider.dart';

class SkillList extends StatefulWidget {
  const SkillList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SkillListState2 createState() => _SkillListState2();
}

class _SkillListState2 extends State<SkillList> {
  final TextEditingController _searchNameController = TextEditingController();
  String _searchNameQuery = '';
  String? _selectedType;
  bool _filtersVisible = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final skillsProvider =
          Provider.of<SkillsProvider>(context, listen: false);

      if (skillsProvider.skills.isEmpty) {
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
      _searchNameController.clear();
      _selectedType = null;
    });

    Provider.of<SkillsProvider>(context, listen: false).clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final skillsProvider = Provider.of<SkillsProvider>(context);
    final filteredSkills = skillsProvider.skills;
    final colorScheme = Theme.of(context).colorScheme;

    if (!skillsProvider.hasData && !skillsProvider.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final p = Provider.of<SkillsProvider>(context, listen: false);
        if (!p.hasData && !p.isLoading) p.fetchSkills();
      });
    }

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest,
      body: Column(
        children: [
          if (_filtersVisible) _buildFiltersSection(context, skillsProvider),

          // Lista de habilidades
          Expanded(
            child: skillsProvider.isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: colorScheme.primary),
                        const SizedBox(height: 16),
                        Text(
                          l10n.loadingSkills,
                          style: TextStyle(
                            fontSize: 16,
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  )
                : filteredSkills.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.noSkillsFound,
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
                        itemCount: filteredSkills.length,
                        itemBuilder: (context, index) {
                          final skill = filteredSkills[index];

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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SkillDetails(
                                        skillsIds: [skill.id],
                                        skillsLevels: [1],
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Header de la habilidad
                                      Row(
                                        children: [
                                          // Icono de la habilidad
                                          SizedBox(
                                            width: 60,
                                            height: 60,
                                            child: Center(
                                              child: SkillSpriteIcon(
                                                iconId: skill.icon?.id,
                                                iconKind: skill.icon?.kind,
                                                size: 60,
                                                fallback: Icon(
                                                  Icons.auto_awesome,
                                                  color: _getTypeColor(skill.kind),
                                                  size: 32,
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
                                                  skill.name,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    color:
                                                        colorScheme.onSurface,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: _getTypeColor(
                                                            skill.kind)
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    border: Border.all(
                                                      color: _getTypeColor(
                                                              skill.kind)
                                                          .withOpacity(0.3),
                                                    ),
                                                  ),
                                                  child: _buildSkillTypeBadge(
                                                    context,
                                                    skill.kind,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.grey[400],
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),

                                      // Descripción
                                      if (skill.description.isNotEmpty) ...[
                                        Text(
                                          skill.description,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: colorScheme.onSurface
                                                .withOpacity(0.8),
                                            height: 1.4,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
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
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleFiltersVisibility,
        backgroundColor: colorScheme.primary,
        child: Icon(
          _filtersVisible ? Icons.close : Icons.tune,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildFiltersSection(
    BuildContext context,
    SkillsProvider skillsProvider,
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
            _applyFilters(skillsProvider);
          },
          hintText: l10n.enterSkillName,
          prefixIcon: Icon(Icons.search, color: colorScheme.primary),
        ),
        ListFilterFieldConfig.select(
          id: 'type',
          label: l10n.type,
          value: _selectedType,
          onSelectChanged: (selectedType) {
            setState(() {
              _selectedType = selectedType as String?;
            });
            _applyFilters(skillsProvider);
          },
          options: ['Weapon', 'Armor', 'Group', 'Set']
              .map(
                (type) => ListFilterOption(
                  value: type,
                  label: _getSkillTypeLabel(context, type),
                  leading: _buildSkillTypeFilterIcon(type),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  void _applyFilters(SkillsProvider skillsProvider) {
    skillsProvider.applyFilters(
      name: _searchNameQuery,
      kind: _selectedType?.toLowerCase(),
    );
  }

  Widget _buildSkillTypeFilterIcon(String type) {
    final kindLower = type.toLowerCase();
    final color = _getTypeColor(type);

    switch (kindLower) {
      case 'weapon':
        return GearSpriteIcon(
          column: weaponColumnByKind['great-sword']!,
          rarity: 1,
          size: 18,
          fallback: Icon(
            Icons.gps_fixed,
            size: 18,
            color: color,
          ),
        );
      case 'armor':
        return GearSpriteIcon(
          column: armorColumnByKind['head']!,
          rarity: 1,
          size: 18,
          fallback: Icon(
            Icons.shield,
            size: 18,
            color: color,
          ),
        );
      case 'group':
      case 'set':
        return SkillSpriteIcon(
          iconKind: kindLower,
          size: 18,
          fallback: Icon(
            Icons.category,
            size: 18,
            color: color,
          ),
        );
      default:
        return Icon(
          Icons.category,
          size: 18,
          color: color,
        );
    }
  }

  Widget _buildSkillTypeBadge(BuildContext context, String kind) {
    final typeColor = _getTypeColor(kind);
    final kindLower = kind.toLowerCase();

    Widget? leadingIcon;
    if (kindLower == 'weapon') {
      leadingIcon = GearSpriteIcon(
        column: weaponColumnByKind['great-sword']!,
        rarity: 1,
        size: 14,
        fallback: Icon(
          Icons.gps_fixed,
          size: 14,
          color: typeColor,
        ),
      );
    } else if (kindLower == 'armor') {
      leadingIcon = GearSpriteIcon(
        column: armorColumnByKind['head']!,
        rarity: 1,
        size: 14,
        fallback: Icon(
          Icons.shield,
          size: 14,
          color: typeColor,
        ),
      );
    } else if (kindLower == 'group' || kindLower == 'set') {
      leadingIcon = SkillSpriteIcon(
        iconKind: kindLower,
        size: 14,
        fallback: Icon(
          Icons.category,
          size: 14,
          color: typeColor,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leadingIcon != null) ...[
          leadingIcon,
          const SizedBox(width: 6),
        ],
        Text(
          _getSkillTypeLabel(context, kind),
          style: TextStyle(
            fontSize: 12,
            color: typeColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _getSkillTypeLabel(BuildContext context, String type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type.toLowerCase()) {
      case 'weapon':
        return l10n.typeWeapon;
      case 'armor':
        return l10n.typeArmor;
      case 'group':
        return l10n.typeGroup;
      case 'set':
        return l10n.typeSet;
      default:
        return type;
    }
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'weapon':
        return Colors.red[400]!;
      case 'armor':
        return Colors.blue[400]!;
      case 'group':
        return Colors.green[400]!;
      case 'set':
        return Colors.purple[400]!;
      default:
        return Colors.grey[400]!;
    }
  }
}
