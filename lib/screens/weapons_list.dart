import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/skill_sprite_icon.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/skills.dart' as skills_model;
import 'package:mhwilds_app/models/weapon.dart';
import 'package:mhwilds_app/providers/en_names_cache.dart';
import 'package:mhwilds_app/components/rarity_chip.dart';
import 'package:mhwilds_app/providers/skills_provider.dart';
import 'package:mhwilds_app/providers/weapons_provider.dart';
import 'package:mhwilds_app/screens/weapon_details.dart';
import 'package:mhwilds_app/utils/weapon_utils.dart';
import 'package:mhwilds_app/components/sharpness_bar.dart';
import 'package:mhwilds_app/components/list_filters_panel.dart';
import 'package:mhwilds_app/components/decoration_sprite_icon.dart';
import 'package:mhwilds_app/components/gear_sprite_icon.dart';
import 'package:mhwilds_app/components/tree_connector_painter.dart';
import 'package:mhwilds_app/utils/weapon_tree_builder.dart';
import 'package:provider/provider.dart';

part 'weapons_list/display_utils.dart';
part 'weapons_list/weapon_card.dart';
part 'weapons_list/damage_info.dart';
part 'weapons_list/slots_and_sharpness.dart';

class WeaponsList extends StatefulWidget {
  const WeaponsList({super.key});

  @override
  _WeaponsListState createState() => _WeaponsListState();
}

class _WeaponsListState extends State<WeaponsList> {
  final TextEditingController _searchNameController = TextEditingController();
  final TextEditingController _searchSeriesController = TextEditingController();
  String _searchNameQuery = '';
  String _searchSeriesQuery = '';
  String? _selectedKind;
  int? _selectedRarity;
  bool _filtersVisible = false;
  bool _isTreeView = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final weaponsProvider =
          Provider.of<WeaponsProvider>(context, listen: false);
      final skillsProvider = Provider.of<SkillsProvider>(context, listen: false);
      if (!weaponsProvider.hasData) {
        weaponsProvider.fetchWeapons();
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
      _searchSeriesQuery = '';
      _selectedKind = null;
      _selectedRarity = null;
      _searchNameController.clear();
      _searchSeriesController.clear();
    });
    print('WeaponsList: _selectedKind reset to: "$_selectedKind"');
    final provider = Provider.of<WeaponsProvider>(context, listen: false);
    provider.clearFilters();

    // Debug: Verificar que el provider se haya limpiado
    print(
        'WeaponsList: Provider filters cleared, weapons count: ${provider.weapons.length}');
  }


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final weaponsProvider = Provider.of<WeaponsProvider>(context);
    final filteredWeapons = weaponsProvider.weapons;

    if (!weaponsProvider.hasData && !weaponsProvider.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final p = Provider.of<WeaponsProvider>(context, listen: false);
        if (!p.hasData && !p.isLoading) p.fetchWeapons();
      });
    }

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest,
      body: Stack(
        children: [
          _buildWeaponsList(context, weaponsProvider, filteredWeapons),
          Positioned(
            top: 8,
            right: 16,
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  value: false,
                  icon: Icon(Icons.view_list),
                  label: Text('List'),
                ),
                ButtonSegment(
                  value: true,
                  icon: Icon(Icons.account_tree),
                  label: Text('Tree'),
                ),
              ],
              selected: {_isTreeView},
              onSelectionChanged: (Set<bool> newSelection) {
                setState(() {
                  _isTreeView = newSelection.first;
                });
              },
              showSelectedIcon: false,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.selected)) {
                      return colorScheme.primaryContainer;
                    }
                    return colorScheme.surface.withValues(alpha: 0.9);
                  },
                ),
              ),
            ),
          ),
          if (_filtersVisible)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Material(
                elevation: 8,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                clipBehavior: Clip.antiAlias,
                child: _buildFiltersSection(context, weaponsProvider),
              ),
            ),
        ],
      ),
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
      BuildContext context, WeaponsProvider weaponsProvider) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return ListFiltersPanel(
      maxHeight: 340,
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
            _applyFilters(weaponsProvider);
          },
          hintText: l10n.enterWeaponName,
          prefixIcon: Icon(Icons.search, color: colorScheme.primary),
        ),
        ListFilterFieldConfig.text(
          id: 'series',
          label: 'Tree Series', // Temporal label until localizations are updated
          controller: _searchSeriesController,
          onTextChanged: (query) {
            setState(() {
              _searchSeriesQuery = query;
            });
            _applyFilters(weaponsProvider);
          },
          hintText: 'Enter series name...',
          prefixIcon: Icon(Icons.account_tree, color: colorScheme.primary),
        ),
        ListFilterFieldConfig.gridMenu(
          id: 'type',
          label: l10n.type,
          value: _selectedKind,
          onSelectChanged: (selectedKind) {
            setState(() {
              _selectedKind = selectedKind as String?;
            });
            _applyFilters(weaponsProvider);
          },
          options: _weaponTypeOptions(context),
        ),
        ListFilterFieldConfig.gridMenu(
          id: 'rarity',
          label: l10n.rarity,
          value: _selectedRarity,
          onSelectChanged: (selectedRarity) {
            setState(() {
              _selectedRarity = selectedRarity as int?;
            });
            _applyFilters(weaponsProvider);
          },
          options: _rarityOptions(l10n),
        ),
      ],
    );
  }

  void _applyFilters(WeaponsProvider weaponsProvider) {
    weaponsProvider.applyFilters(
      name: _searchNameQuery,
      series: _searchSeriesQuery,
      kind: _selectedKind,
      rarity: _selectedRarity,
    );
  }

  List<ListFilterOption> _weaponTypeOptions(BuildContext context) {
    final weaponTypes = [
      'great-sword',
      'long-sword',
      'sword-shield',
      'dual-blades',
      'hammer',
      'hunting-horn',
      'lance',
      'gunlance',
      'switch-axe',
      'charge-blade',
      'insect-glaive',
      'bow',
      'light-bowgun',
      'heavy-bowgun'
    ];

    return weaponTypes.map((kind) {
      final int? spriteColumn = weaponColumnByKind[kind];
      return ListFilterOption(
        value: kind,
        label: _getWeaponKindLabel(context, kind),
        leading: spriteColumn != null
            ? GearSpriteIcon(
                column: spriteColumn,
                rarity: 1,
                size: 20,
                fallback: Icon(
                  _getWeaponIcon(kind),
                  color: _getKindColor(kind),
                  size: 20,
                ),
              )
            : Icon(
                _getWeaponIcon(kind),
                color: _getKindColor(kind),
                size: 20,
              ),
      );
    }).toList();
  }

  List<ListFilterOption> _rarityOptions(AppLocalizations l10n) {
    return [1, 2, 3, 4, 5, 6, 7, 8].map((rarity) {
      return ListFilterOption(
        value: rarity,
        label: l10n.rarityLevel(rarity),
        leading: Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: _getRarityColor(rarity),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
    }).toList();
  }  Widget _buildWeaponsList(BuildContext context,
      WeaponsProvider weaponsProvider, List<Weapon> filteredWeapons) {
    final colorScheme = Theme.of(context).colorScheme;
    if (weaponsProvider.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.loadingWeapons,
              style: TextStyle(
                  fontSize: 16, color: colorScheme.onSurface.withOpacity(0.7)),
            ),
          ],
        ),
      );
    }

    final Map<String, List<Weapon>> seriesGroups = {};
    if (_isTreeView) {
      for (final w in filteredWeapons) {
        final seriesName = w.series?.name ?? 'No Series';
        if (!seriesGroups.containsKey(seriesName)) {
          seriesGroups[seriesName] = [];
        }
        seriesGroups[seriesName]!.add(w);
      }
    }
    final seriesKeys = seriesGroups.keys.toList()..sort();

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 120, top: 64),
      itemCount: filteredWeapons.isEmpty ? 1 : (_isTreeView ? seriesKeys.length : filteredWeapons.length),
      itemBuilder: (context, index) {
        if (filteredWeapons.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 64),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off,
                      size: 64, color: colorScheme.onSurface.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.noWeaponsFound,
                    style: TextStyle(
                      fontSize: 18,
                      color: colorScheme.onSurface.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.tryAdjustingFilters,
                    style: TextStyle(
                        fontSize: 14, color: colorScheme.onSurface.withValues(alpha: 0.6)),
                  ),
                ],
              ),
            ),
          );
        }
        
        final itemIndex = index;

        if (_isTreeView) {
          final seriesName = seriesKeys[itemIndex];
          final weaponsInSeries = seriesGroups[seriesName]!;
          final roots = _buildSeriesTrees(weaponsInSeries);

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                initiallyExpanded: seriesKeys.length == 1,
                collapsedBackgroundColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                title: Row(
                  children: [
                    Icon(Icons.account_tree_outlined, size: 20, color: colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        seriesName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${weaponsInSeries.length}',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.primary),
                      ),
                    ),
                  ],
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24, left: 8, right: 8, top: 8),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: roots.map((node) => _buildVisualTree(node, context)).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          final weapon = filteredWeapons[itemIndex];
          return _buildWeaponCard(weapon, itemIndex);
        }
      },
    );
  }

  List<TreeNode> _buildSeriesTrees(List<Weapon> seriesWeapons) {
    final roots = seriesWeapons.where((w) {
      if (w.crafting.previous == null) return true;
      return !seriesWeapons.any((other) => other.id == w.crafting.previous?.id);
    }).toList();

    TreeNode buildNode(Weapon w) {
      final children = seriesWeapons.where((child) => child.crafting.previous?.id == w.id).toList();
      return TreeNode(
        weapon: w,
        children: children.map((c) => buildNode(c)).toList(),
      );
    }

    return roots.map((r) => buildNode(r)).toList();
  }

  Widget _buildVisualTree(TreeNode node, BuildContext context, {int depth = 0, List<bool> isLastChildPath = const []}) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (int i = 0; i < depth - 1; i++)
                SizedBox(
                  width: 24,
                  child: isLastChildPath[i]
                      ? null
                      : CustomPaint(
                          painter: StraightLinePainter(
                            color: colorScheme.outlineVariant,
                          ),
                        ),
                ),
              if (depth > 0)
                SizedBox(
                  width: 24,
                  child: CustomPaint(
                    painter: TreeConnectorPainter(
                      isLastChild: isLastChildPath.last,
                      color: colorScheme.outlineVariant,
                    ),
                  ),
                ),
              Container(
                  margin: const EdgeInsets.only(bottom: 4, top: 4, left: 4),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WeaponDetails(weapon: node.weapon)),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          GearSpriteIcon(
                            column: weaponColumnByKind[node.weapon.kind] ?? 0,
                            rarity: node.weapon.rarity,
                            size: 32,
                            fallback: Icon(_getWeaponIcon(node.weapon.kind), size: 24, color: _getKindColor(node.weapon.kind)),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 140,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(node.weapon.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                if (_hasSharpnessData(node.weapon)) ...[
                                  const SizedBox(height: 4),
                                  SharpnessBar(
                                    sharpness: node.weapon.sharpness,
                                    height: 6,
                                    borderRadius: 2,
                                  ),
                                  const SizedBox(height: 4),
                                ],
                                RarityChip(
                                  rarity: node.weapon.rarity,
                                  fontSize: 10,
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 70,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.gps_fixed, size: 14, color: Colors.red[400]),
                                    const SizedBox(width: 2),
                                    Text('${node.weapon.damage.display}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                if (node.weapon.affinity != 0) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.trending_up, size: 14, color: colorScheme.primary),
                                      const SizedBox(width: 2),
                                      Text('${node.weapon.affinity}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (node.children.isNotEmpty)
          ...node.children.asMap().entries.map((entry) {
            final isLast = entry.key == node.children.length - 1;
            return _buildVisualTree(
              entry.value,
              context,
              depth: depth + 1,
              isLastChildPath: [...isLastChildPath, isLast],
            );
          }),
      ],
    );
  }

  Widget _buildWeaponCard(Weapon weapon, int index) {
    final colorScheme = Theme.of(context).colorScheme;
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
                builder: (context) => WeaponDetails(weapon: weapon),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWeaponHeader(weapon),
                const SizedBox(height: 16),
                _buildWeaponStats(weapon),
                if (weapon.slots.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildWeaponSlots(weapon),
                ],
                if (_hasSharpnessData(weapon)) ...[
                  const SizedBox(height: 16),
                  _buildSharpnessSection(weapon),
                ],
                if (weapon.skills.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildWeaponSkills(weapon),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeaponHeader(Weapon weapon) {
    final colorScheme = Theme.of(context).colorScheme;
    final int? spriteColumn = weaponColumnByKind[weapon.kind];

    return Row(
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: Center(
            child: spriteColumn != null
                ? GearSpriteIcon(
                    column: spriteColumn,
                    rarity: weapon.rarity,
                    size: 42,
                    fallback: Icon(
                      _getWeaponIcon(weapon.kind),
                      color: _getKindColor(weapon.kind),
                      size: 42,
                    ),
                  )
                : Icon(
                    _getWeaponIcon(weapon.kind),
                    color: _getKindColor(weapon.kind),
                    size: 42,
                  ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                weapon.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              RarityChip(rarity: weapon.rarity),
            ],
          ),
        ),
        Icon(Icons.arrow_forward_ios,
            color: colorScheme.onSurface.withOpacity(0.6), size: 20),
      ],
    );
  }

  Widget _buildWeaponStats(Weapon weapon) {
    final colorScheme = Theme.of(context).colorScheme;
    final List<Widget> statRows = [];

    // Sección de daño físico
    statRows.add(Row(
      children: [
        Text(
          '${AppLocalizations.of(context)!.physicalDamage}:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        const Spacer(),
        Row(
          children: [
            Text(
              '${weapon.damage.display}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.gps_fixed,
              size: 16,
              color: Colors.red[400],
            ),
          ],
        ),
      ],
    ));

    // Afinidad
    statRows.add(const SizedBox(height: 12));
    statRows.add(Row(
      children: [
        Text(
          '${AppLocalizations.of(context)!.affinity}:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        const Spacer(),
        Row(
          children: [
            Text(
              '${weapon.affinity > 0 ? '+' : ''}${weapon.affinity}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.trending_up,
              size: 16,
              color: colorScheme.primary,
            ),
          ],
        ),
      ],
    ));

    // Sección de daño elemental
    if (weapon.specials != null && _hasElementalDamage(weapon)) {
      statRows.add(const SizedBox(height: 12));
      statRows.add(WeaponDisplayUtils.buildElementalDamageRow(context, weapon));
    }

    // Información adicional específica por arma
    final additionalInfo =
        WeaponDisplayUtils.buildAdditionalDamageInfo(context, weapon);
    if (additionalInfo is! SizedBox) {
      statRows.add(const SizedBox(height: 12));
      statRows.add(additionalInfo);
    }

    // Sección de defense bonus
    if (weapon.defenseBonus > 0) {
      statRows.add(const SizedBox(height: 12));
      statRows.add(Row(
        children: [
          Text(
            '${AppLocalizations.of(context)!.defense}:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                '+${weapon.defenseBonus}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.shield,
                size: 16,
                color: colorScheme.primary,
              ),
            ],
          ),
        ],
      ));
    }

    // Elderseal
    if (weapon.elderseal != null) {
      statRows.add(const SizedBox(height: 12));
      statRows.add(Row(
        children: [
          Text(
            'Elderseal:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                weapon.elderseal![0].toUpperCase() + weapon.elderseal!.substring(1),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.auto_awesome,
                size: 16,
                color: colorScheme.primary,
              ),
            ],
          ),
        ],
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: statRows,
    );
  }

  // Método auxiliar para verificar si hay daño elemental
  bool _hasElementalDamage(Weapon weapon) {
    if (weapon.specials is List) {
      final specials = weapon.specials as List;
      return specials.any((special) {
        if (special is Map<String, dynamic>) {
          return (special['kind'] == 'element' ||
                  special['kind'] == 'status') &&
              special['damage'] != null &&
              special['damage']['raw'] > 0;
        }
        return false;
      });
    }
    return false;
  }

  // Método auxiliar para verificar si hay información adicional de daño
  bool _hasAdditionalDamageInfo(Weapon weapon) {
    switch (weapon.kind) {
      case 'bow':
        return weapon.coatings != null && weapon.coatings!.isNotEmpty;
      case 'charge-blade':
        return weapon.phial != null;
      case 'gunlance':
        return weapon.shell != null && weapon.shellLevel != null;
      case 'switch-axe':
        return weapon.phial != null;
      case 'hunting-horn':
        return weapon.melody != null ||
            weapon.echoBubble != null ||
            weapon.echoWave != null;
      case 'heavy-bowgun':
      case 'light-bowgun':
        return weapon.ammo != null && weapon.ammo!.isNotEmpty;
      case 'insect-glaive':
        return weapon.kinsectLevel != null && weapon.kinsectLevel! > 0;
      default:
        return false;
    }
  }

  Widget _buildWeaponSkills(Weapon weapon) {
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
        ...weapon.skills.map((skill) => Container(
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
                          iconId:
                              _skillIconForId(skill.skill.id, context)?.id,
                          iconKind:
                              _skillIconForId(skill.skill.id, context)?.kind,
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

  String _getWeaponKindLabel(BuildContext context, String kind) {
    final l10n = AppLocalizations.of(context)!;
    switch (kind) {
      case 'great-sword':
        return l10n.weaponKindGreatSword;
      case 'long-sword':
        return l10n.weaponKindLongSword;
      case 'sword-shield':
        return l10n.weaponKindSwordShield;
      case 'dual-blades':
        return l10n.weaponKindDualBlades;
      case 'hammer':
        return l10n.weaponKindHammer;
      case 'hunting-horn':
        return l10n.weaponKindHuntingHorn;
      case 'lance':
        return l10n.weaponKindLance;
      case 'gunlance':
        return l10n.weaponKindGunlance;
      case 'switch-axe':
        return l10n.weaponKindSwitchAxe;
      case 'charge-blade':
        return l10n.weaponKindChargeBlade;
      case 'insect-glaive':
        return l10n.weaponKindInsectGlaive;
      case 'bow':
        return l10n.weaponKindBow;
      case 'light-bowgun':
        return l10n.weaponKindLightBowgun;
      case 'heavy-bowgun':
        return l10n.weaponKindHeavyBowgun;
      default:
        return kind;
    }
  }

  IconData _getWeaponIcon(String kind) {
    switch (kind) {
      case 'great-sword':
      case 'long-sword':
      case 'dual-blades':
      case 'lance':
      case 'gunlance':
      case 'switch-axe':
      case 'charge-blade':
      case 'insect-glaive':
      case 'light-bowgun':
      case 'heavy-bowgun':
        return Icons.gps_fixed;
      case 'sword-shield':
        return Icons.shield;
      case 'hammer':
        return Icons.build;
      case 'hunting-horn':
        return Icons.music_note;
      case 'bow':
        return Icons.arrow_upward;
      default:
        return Icons.gps_fixed;
    }
  }

  Color _getKindColor(String kind) {
    switch (kind) {
      case 'great-sword':
        return Colors.red[400]!;
      case 'long-sword':
        return Colors.orange[400]!;
      case 'sword-shield':
        return Colors.blue[400]!;
      case 'dual-blades':
        return Colors.purple[400]!;
      case 'hammer':
        return Colors.brown[400]!;
      case 'hunting-horn':
        return Colors.green[400]!;
      case 'lance':
        return Colors.indigo[400]!;
      case 'gunlance':
        return Colors.teal[400]!;
      case 'switch-axe':
        return Colors.deepOrange[400]!;
      case 'charge-blade':
        return Colors.cyan[400]!;
      case 'insect-glaive':
        return Colors.lime[400]!;
      case 'bow':
        return Colors.amber[400]!;
      case 'light-bowgun':
        return Colors.pink[400]!;
      case 'heavy-bowgun':
        return Colors.deepPurple[400]!;
      default:
        return Colors.grey[400]!;
    }
  }

  Color _getRarityColor(int rarity) {
    return rarityColorFromSprite(rarity);
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
