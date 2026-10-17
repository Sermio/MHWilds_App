import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/async_list_body.dart';
import 'package:mhwilds_app/components/asset_thumb.dart';
import 'package:mhwilds_app/components/c_chip.dart';
import 'package:mhwilds_app/components/list_filters_panel.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/monster.dart';
import 'package:mhwilds_app/providers/en_names_cache.dart';
import 'package:mhwilds_app/providers/locations_provider.dart';
import 'package:mhwilds_app/providers/monsters_provider.dart';
import 'package:mhwilds_app/screens/map_details.dart';
import 'package:mhwilds_app/screens/monster_details.dart';
import 'package:provider/provider.dart';
import 'package:mhwilds_app/utils/game_colors.dart';
import 'package:mhwilds_app/utils/spacing.dart';
import 'package:mhwilds_app/utils/weapon_utils.dart';

class MonstersList extends StatefulWidget {
  const MonstersList({super.key});

  @override
  State<MonstersList> createState() => _MonstersListState();
}

class _MonstersListState extends State<MonstersList> {
  // El filtro vive en MonstersProvider; aquí solo el controlador del texto.
  late final TextEditingController _searchNameController;
  bool _filtersVisible = false;

  @override
  void initState() {
    super.initState();
    _searchNameController = TextEditingController(
        text: context.read<MonstersProvider>().filter.name);

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
    });
  }

  void _toggleFiltersVisibility() {
    setState(() {
      _filtersVisible = !_filtersVisible;
    });
  }

  void _resetFilters() {
    _searchNameController.clear();
    context.read<MonstersProvider>().clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final monstersProvider = Provider.of<MonstersProvider>(context);
    final zonesProvider = Provider.of<LocationsProvider>(context);
    final monsters = monstersProvider.filteredMonsters;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest,
      body: Stack(
        children: [
          // Lista de monstruos
          AsyncListBody<Monster>(
            state: monstersProvider.state,
            isOffline: monstersProvider.isOffline,
            loadingLabel: l10n.loadingMonsters,
            emptyTitle: l10n.noMonstersFound,
            emptySubtitle: l10n.tryAdjustingFilters,
            onRetry: monstersProvider.fetchMonsters,
            onRefresh: () => monstersProvider.refresh(force: true),
            isEmpty: (_) => monsters.isEmpty,
            builder: (context, _) => ListView.builder(
              key: const PageStorageKey('monsters-list'),
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 120, top: AppSpacing.lg),
              itemCount: monsters.length,
              itemBuilder: (context, index) {
                final monster = monsters[index];

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg)
                      .copyWith(bottom: 16),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                          borderRadius: BorderRadius.circular(
                                              AppRadius.md),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              AppRadius.md),
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
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: AppSpacing.sm,
                                            vertical: AppSpacing.xs),
                                        decoration: BoxDecoration(
                                          color: colorScheme.primary
                                              .withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: colorScheme.primary
                                                .withValues(alpha: 0.3),
                                          ),
                                        ),
                                        child: Text(
                                          monster.displaySpecies(l10n),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  color: colorScheme.primary,
                                                  fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      _buildRankBadges(monster, context),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: colorScheme.onSurfaceVariant,
                                  size: 20,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Descripción
                            if (monster.description.isNotEmpty) ...[
                              Text(
                                monster.description,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: colorScheme.onSurface
                                            .withValues(alpha: 0.7),
                                        height: 1.4),
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
          ),
          if (_filtersVisible)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Material(
                elevation: 8,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(24)),
                clipBehavior: Clip.antiAlias,
                child: _buildFiltersSection(
                    context, monstersProvider, zonesProvider),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: _filtersVisible
            ? AppLocalizations.of(context)!.close
            : AppLocalizations.of(context)!.filters,
        onPressed: _toggleFiltersVisibility,
        backgroundColor: colorScheme.primary,
        child: Icon(
          _filtersVisible ? Icons.close : Icons.tune,
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }

  List<ListFilterOption> _speciesOptions(
      MonstersProvider monstersProvider, AppLocalizations l10n) {
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
          onTextChanged: (query) => monstersProvider
              .setFilter(monstersProvider.filter.copyWith(name: query)),
          hintText: l10n.enterMonsterName,
          prefixIcon: Icon(Icons.search, color: colorScheme.primary),
        ),
        ListFilterFieldConfig.select(
          id: 'species',
          label: l10n.searchBySpecies,
          value: monstersProvider.filter.species,
          onSelectChanged: (selectedSpecies) => monstersProvider.setFilter(
              monstersProvider.filter
                  .copyWith(species: () => selectedSpecies as String?)),
          options: _speciesOptions(monstersProvider, l10n),
        ),
        ListFilterFieldConfig.select(
          id: 'rank',
          label: l10n.rank,
          value: monstersProvider.filter.rank,
          onSelectChanged: (selectedRank) => monstersProvider.setFilter(
              monstersProvider.filter
                  .copyWith(rank: () => selectedRank as String?)),
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
    final selected = monstersProvider.filter.locations;

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
              color: selected.contains(zone.name)
                  ? colorScheme.onPrimary
                  : colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: GameColors.of(context).zone(zone.id ?? 0),
          selectedColor: colorScheme.primary,
          selected: selected.contains(zone.name),
          onSelected: (isSelected) => monstersProvider
              .setFilter(monstersProvider.filter.copyWith(locations: [
            for (final l in selected)
              if (l != zone.name) l,
            if (isSelected) zone.name!,
          ])),
          elevation: 2,
          pressElevation: 4,
        );
      }).toList(),
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

    final List<Widget> overlays = [];

    // Posicionar las debilidades en la esquina inferior derecha del icono
    for (int i = 0; i < elementalWeaknesses.length && i < 3; i++) {
      final weakness = elementalWeaknesses[i];
      final element = weakness.element?.toLowerCase();

      if (element != null) {
        overlays.add(
          Positioned(
            bottom: 2,
            right: 2 + (i * 15), // Espaciado horizontal de derecha a izquierda
            child: AssetThumb('assets/imgs/elements/$element.webp',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                semanticLabel: WeaponUtils.elementLabel(element)),
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
        Text(
          AppLocalizations.of(context)!.locationsLabel,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withValues(alpha: 0.8)),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: monster.locations.map((loc) {
            return Cchip(
              itemName: loc.name,
              itemIdForColor: loc.id,
              getItemColor: GameColors.of(context).zone,
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
    final enNamesCache = context.watch<EnNamesCache>();
    final imageName = enNamesCache.nameForMonsterImage(monsterId, monsterName);

    if (imageName == null) {
      // Cache no cargado, mostrar placeholder
      return Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Icon(Icons.image_not_supported,
            color: Theme.of(context).colorScheme.onSurfaceVariant),
      );
    }

    final imagePath =
        'assets/imgs/monster_icons/${imageName.toLowerCase().replaceAll(' ', '_')}.webp';
    return AssetThumb(
      imagePath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // Si la imagen no existe, mostrar placeholder
        return Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Icon(Icons.image_not_supported,
              color: Theme.of(context).colorScheme.onSurfaceVariant),
        );
      },
    );
  }
}
