import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/c_chip.dart';
import 'package:mhwilds_app/components/list_filters_panel.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/monster.dart';
import 'package:mhwilds_app/providers/en_names_cache.dart';
import 'package:mhwilds_app/providers/locations_provider.dart';
import 'package:mhwilds_app/providers/monsters_provider.dart';
import 'package:mhwilds_app/screens/map_details.dart';
import 'package:mhwilds_app/screens/monster_details.dart';
import 'package:mhwilds_app/utils/utils.dart';
import 'package:provider/provider.dart';

class MonstersList extends StatefulWidget {
  const MonstersList({super.key});

  @override
  State<MonstersList> createState() => _MonstersListState();
}

class _MonstersListState extends State<MonstersList> {
  final TextEditingController _searchNameController = TextEditingController();
  String _searchNameQuery = '';
  String? _selectedSpecies;
  String? _selectedRank;
  final List<String> _selectedLocations = [];
  bool _filtersVisible = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MonstersProvider>(context, listen: false);
      if (!provider.hasData) {
        provider.fetchMonsters();
      }

      final zonesProvider =
          Provider.of<LocationsProvider>(context, listen: false);
      if (!zonesProvider.hasData) {
        zonesProvider.fetchZones();
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
      _selectedSpecies = null;
      _selectedRank = null;
      _selectedLocations.clear();
      _searchNameController.clear();
    });
    Provider.of<MonstersProvider>(context, listen: false).clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final monstersProvider = Provider.of<MonstersProvider>(context);
    final zonesProvider = Provider.of<LocationsProvider>(context);
    final monsters = monstersProvider.filteredMonsters;
    final colorScheme = Theme.of(context).colorScheme;

    // Tras cambiar idioma se invalida la caché; al volver a esta pantalla
    // initState no se ejecuta de nuevo, así que forzamos recarga si no hay datos.
    if (!monstersProvider.hasData && !monstersProvider.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final p = Provider.of<MonstersProvider>(context, listen: false);
        if (!p.hasData && !p.isLoading) p.fetchMonsters();
      });
    }
    if (!zonesProvider.hasData && !zonesProvider.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final p = Provider.of<LocationsProvider>(context, listen: false);
        if (!p.hasData && !p.isLoading) p.fetchZones();
      });
    }

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest,
      body: Stack(
        children: [
          // Lista de monstruos
          monstersProvider.isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: colorScheme.primary),
                        const SizedBox(height: 16),
                        Text(
                          l10n.loadingMonsters,
                          style: TextStyle(
                            fontSize: 16,
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 120, top: 16),
                    itemCount: monsters.isEmpty ? 1 : monsters.length,
                    itemBuilder: (context, index) {                      if (monsters.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 64),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  l10n.noMonstersFound,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: colorScheme.onSurface.withValues(alpha: 0.8),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  l10n.tryAdjustingFilters,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final monster = monsters[index];

                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 16),
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
                                      builder: (context) => MonsterDetails(
                                        monsterId: monster.id,
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
                                      // Header del monstruo
                                      Row(
                                        children: [
                                          Hero(
                                            tag: monster.name,
                                            child: Stack(
                                              children: [
                                                Container(
                                                  width: 100,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    child: _buildMonsterIcon(
                                                      context,
                                                      monster.id,
                                                      monster.name,
                                                    ),
                                                  ),
                                                ),
                                                // Superposición de debilidades elementales
                                                ..._buildElementalWeaknessOverlays(
                                                    monster),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  monster.name,
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
                                                    color: colorScheme.primary
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    border: Border.all(
                                                      color: colorScheme.primary
                                                          .withOpacity(0.3),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    monster.displaySpecies(l10n),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          colorScheme.primary,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                _buildRankBadges(monster, context),
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

                                      // Descripción
                                      if (monster.description.isNotEmpty) ...[
                                        Text(
                                          monster.description,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: colorScheme.onSurface
                                                .withOpacity(0.7),
                                            height: 1.4,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 16),
                                      ],

                                      // Ubicaciones
                                      _buildLocationsSection(context, monster),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
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
                child: _buildFiltersSection(context, monstersProvider, zonesProvider),
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

  List<ListFilterOption> _speciesOptions(MonstersProvider monstersProvider, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    final speciesSet = <String, String>{}; // rawSpecies -> displaySpecies
    for (final monster in monstersProvider.allMonsters) {
      if (monster.species.isNotEmpty) {
        speciesSet[monster.species] = monster.displaySpecies(l10n);
      }
    }
    final options = speciesSet.entries.map((e) {
      return ListFilterOption(
        value: e.key,
        label: e.value,
        leading: Icon(Icons.category, size: 20, color: colorScheme.primary),
      );
    }).toList();
    options.sort((a, b) => a.label.compareTo(b.label));
    return options;
  }

  List<ListFilterOption> _rankOptions() {
    final l10n = AppLocalizations.of(context)!;
    return [
      ListFilterOption(
        value: 'low',
        label: l10n.lowRank,
        leading: Icon(Icons.star_outline, size: 20, color: Colors.blue[400]),
      ),
      ListFilterOption(
        value: 'high',
        label: l10n.highRank,
        leading: Icon(Icons.star_half, size: 20, color: Colors.orange[400]),
      ),
      ListFilterOption(
        value: 'master',
        label: l10n.masterRank,
        leading: Icon(Icons.star, size: 20, color: Colors.purple[400]),
      ),
    ];
  }

  Widget _buildFiltersSection(
    BuildContext context,
    MonstersProvider monstersProvider,
    LocationsProvider zonesProvider,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return ListFiltersPanel(
      title: l10n.filters,
      resetLabel: l10n.reset,
      onReset: _resetFilters,
      maxHeight: 300,
      fields: [
        ListFilterFieldConfig.text(
          id: 'name',
          label: l10n.searchByName,
          controller: _searchNameController,
          onTextChanged: (query) {
            setState(() {
              _searchNameQuery = query;
            });
            _applyFilters(monstersProvider);
          },
          hintText: l10n.enterMonsterName,
          prefixIcon: Icon(Icons.search, color: colorScheme.primary),
        ),
        ListFilterFieldConfig.select(
          id: 'species',
          label: l10n.searchBySpecies,
          value: _selectedSpecies,
          onSelectChanged: (selectedSpecies) {
            setState(() {
              _selectedSpecies = selectedSpecies as String?;
            });
            _applyFilters(monstersProvider);
          },
          options: _speciesOptions(monstersProvider, l10n),
        ),
        ListFilterFieldConfig.select(
          id: 'rank',
          label: l10n.rank,
          value: _selectedRank,
          onSelectChanged: (selectedRank) {
            setState(() {
              _selectedRank = selectedRank as String?;
            });
            _applyFilters(monstersProvider);
          },
          options: _rankOptions(),
        ),
        ListFilterFieldConfig.custom(
          id: 'locations',
          label: l10n.locations,
          customBuilder: (_) => _buildLocationsFilter(
            context,
            monstersProvider,
            zonesProvider,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationsFilter(
    BuildContext context,
    MonstersProvider monstersProvider,
    LocationsProvider zonesProvider,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    if (zonesProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: zonesProvider.zones.map((zone) {
        return FilterChip(
          label: Text(
            zone.name!,
            style: TextStyle(
              color: _selectedLocations.contains(zone.name)
                  ? colorScheme.onPrimary
                  : colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: zoneBackgroundColor(zone.id ?? 0),
          selectedColor: colorScheme.primary,
          selected: _selectedLocations.contains(zone.name),
          onSelected: (isSelected) {
            setState(() {
              if (isSelected) {
                _selectedLocations.add(zone.name!);
              } else {
                _selectedLocations.remove(zone.name);
              }
            });
            _applyFilters(monstersProvider);
          },
          elevation: 2,
          pressElevation: 4,
        );
      }).toList(),
    );
  }

  void _applyFilters(MonstersProvider monstersProvider) {
    monstersProvider.applyFilters(
      name: _searchNameQuery,
      species: _selectedSpecies,
      rank: _selectedRank,
      locations: _selectedLocations,
      l10n: AppLocalizations.of(context)!,
    );
  }

  Widget _buildRankBadges(Monster monster, BuildContext context) {
    if (monster.availableRanks.isEmpty) return const SizedBox.shrink();
    
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: monster.availableRanks.map((rank) {
        Color bgColor;
        String label;
        switch (rank) {
          case 'low':
            bgColor = Colors.blue[400]!;
            label = 'LR';
            break;
          case 'high':
            bgColor = Colors.orange[400]!;
            label = 'HR';
            break;
          case 'master':
            bgColor = Colors.purple[400]!;
            label = 'MR';
            break;
          default:
            bgColor = Colors.grey;
            label = rank.toUpperCase();
        }
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: bgColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: bgColor.withValues(alpha: 0.5)),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: bgColor,
            ),
          ),
        );
      }).toList(),
    );
  }

  List<Widget> _buildElementalWeaknessOverlays(Monster monster) {
    // Debug: imprimir las debilidades del monstruo

    // Mostrar todas las debilidades elementales, no solo las de nivel 2+
    final elementalWeaknesses = monster.weaknesses.where((w) {
      return w.kind == 'element';
    }).toList();

    if (elementalWeaknesses.isEmpty) return [];

    List<Widget> overlays = [];

    // Posicionar las debilidades en la esquina inferior derecha del icono
    for (int i = 0; i < elementalWeaknesses.length && i < 3; i++) {
      final weakness = elementalWeaknesses[i];
      final element = weakness.element?.toLowerCase();

      if (element != null) {
        overlays.add(
          Positioned(
            bottom: 2,
            right: 2 + (i * 15), // Espaciado horizontal de derecha a izquierda
            child: Image.asset(
              'assets/imgs/elements/$element.webp',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
        );
      }
    }

    return overlays;
  }

  Widget _buildLocationsSection(BuildContext context, Monster monster) {
    if (monster.locations.isEmpty) return const SizedBox.shrink();
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              AppLocalizations.of(context)!.locationsLabel,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: monster.locations.map((loc) {
            return Cchip(
              itemName: loc.name,
              itemIdForColor: loc.id,
              getItemColor: zoneBackgroundColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MonsterMapDetails(mapId: loc.id),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMonsterIcon(
      BuildContext context, int monsterId, String monsterName) {
    final enNamesCache = Provider.of<EnNamesCache>(context, listen: false);
    final imageName = enNamesCache.nameForMonsterImage(monsterId, monsterName);

    if (imageName == null) {
      // Cache no cargado, mostrar placeholder
      return Container(
        color: Colors.grey[300],
        child: Icon(Icons.image_not_supported, color: Colors.grey[600]),
      );
    }

    final imagePath =
        'assets/imgs/monster_icons/${imageName.toLowerCase().replaceAll(' ', '_')}.png';
    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // Si la imagen no existe, mostrar placeholder
        return Container(
          color: Colors.grey[300],
          child: Icon(Icons.image_not_supported, color: Colors.grey[600]),
        );
      },
    );
  }
}
