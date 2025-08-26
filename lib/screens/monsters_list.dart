import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/c_chip.dart';
import 'package:mhwilds_app/models/monster.dart';
import 'package:mhwilds_app/providers/locations_provider.dart';
import 'package:mhwilds_app/providers/monsters_provider.dart';
import 'package:mhwilds_app/screens/map_details.dart';
import 'package:mhwilds_app/screens/monster_details.dart';
import 'package:mhwilds_app/utils/colors.dart';
import 'package:mhwilds_app/utils/utils.dart';
import 'package:mhwilds_app/widgets/custom_card.dart';
import 'package:provider/provider.dart';

class MonstersList extends StatefulWidget {
  const MonstersList({super.key});

  @override
  State<MonstersList> createState() => _MonstersListState();
}

class _MonstersListState extends State<MonstersList> {
  final TextEditingController _searchNameController = TextEditingController();
  final TextEditingController _searchSpeciesController =
      TextEditingController();
  String _searchNameQuery = '';
  String _searchSpeciesQuery = '';
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
      _searchSpeciesQuery = '';
      _selectedLocations.clear();
      _searchNameController.clear();
      _searchSpeciesController.clear();
    });
    Provider.of<MonstersProvider>(context, listen: false).clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    final monstersProvider = Provider.of<MonstersProvider>(context);
    final zonesProvider = Provider.of<LocationsProvider>(context);
    final monsters = monstersProvider.filteredMonsters;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Filtros mejorados
          if (_filtersVisible) ...[
            Container(
              margin: const EdgeInsets.all(16),
              height: 300, // Altura fija para los filtros
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header de filtros (fijo)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.filter_list,
                            color: AppColors.goldSoft),
                        const SizedBox(width: 8),
                        const Text(
                          'Filters',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: _resetFilters,
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text('Reset'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.goldSoft,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Contenido de filtros con scroll
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Campo de búsqueda por nombre
                          TextField(
                            controller: _searchNameController,
                            onChanged: (query) {
                              setState(() {
                                _searchNameQuery = query;
                              });
                              monstersProvider.applyFilters(
                                name: _searchNameQuery,
                                species: _searchSpeciesQuery,
                                locations: _selectedLocations,
                              );
                            },
                            decoration: InputDecoration(
                              labelText: 'Search by Name',
                              hintText: 'Enter monster name...',
                              prefixIcon: const Icon(Icons.search,
                                  color: AppColors.goldSoft),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: AppColors.goldSoft, width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Campo de búsqueda por especie
                          TextField(
                            controller: _searchSpeciesController,
                            onChanged: (query) {
                              setState(() {
                                _searchSpeciesQuery = query;
                              });
                              monstersProvider.applyFilters(
                                name: _searchNameQuery,
                                species: _searchSpeciesQuery,
                                locations: _selectedLocations,
                              );
                            },
                            decoration: InputDecoration(
                              labelText: 'Search by Species',
                              hintText: 'Enter species...',
                              prefixIcon: const Icon(Icons.category,
                                  color: AppColors.goldSoft),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: AppColors.goldSoft, width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Filtros de ubicación
                          const Text(
                            'Locations',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          zonesProvider.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : Wrap(
                                  spacing: 8.0,
                                  runSpacing: 8.0,
                                  children: zonesProvider.zones.map((zone) {
                                    return FilterChip(
                                      label: Text(
                                        zone.name!,
                                        style: TextStyle(
                                          color: _selectedLocations
                                                  .contains(zone.name)
                                              ? Colors.white
                                              : Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      backgroundColor:
                                          zoneBackgroundColor(zone.name!),
                                      selectedColor: AppColors.goldSoft,
                                      selected: _selectedLocations
                                          .contains(zone.name),
                                      onSelected: (isSelected) {
                                        setState(() {
                                          if (isSelected) {
                                            _selectedLocations.add(zone.name!);
                                          } else {
                                            _selectedLocations
                                                .remove(zone.name);
                                          }
                                        });
                                        monstersProvider.applyFilters(
                                          name: _searchNameQuery,
                                          species: _searchSpeciesQuery,
                                          locations: _selectedLocations,
                                        );
                                      },
                                      elevation: 2,
                                      pressElevation: 4,
                                    );
                                  }).toList(),
                                ),
                          const SizedBox(
                              height: 20), // Espacio al final para scroll
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Lista de monstruos
          Expanded(
            child: monstersProvider.isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: AppColors.goldSoft),
                        SizedBox(height: 16),
                        Text(
                          'Loading monsters...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : monsters.isEmpty
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
                              'No monsters found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try adjusting your filters',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        itemCount: monsters.length,
                        itemBuilder: (context, index) {
                          var monster = monsters[index];

                          return BounceInLeft(
                            duration: const Duration(milliseconds: 600),
                            delay: Duration(milliseconds: index * 50),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
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
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: AppColors
                                                              .goldSoft
                                                              .withOpacity(0.3),
                                                          blurRadius: 8,
                                                          offset: const Offset(
                                                              0, 2),
                                                        ),
                                                      ],
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      child: Image.asset(
                                                        'assets/imgs/monster_icons/${monster.name.toLowerCase().replaceAll(' ', '_')}.png',
                                                        fit: BoxFit.cover,
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
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.goldSoft
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      border: Border.all(
                                                        color: AppColors
                                                            .goldSoft
                                                            .withOpacity(0.3),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      monster.species,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            AppColors.goldSoft,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
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
                                        if (monster.description.isNotEmpty) ...[
                                          Text(
                                            monster.description,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                              height: 1.4,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 16),
                                        ],

                                        // Ubicaciones
                                        _buildLocationsSection(monster),
                                      ],
                                    ),
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
        backgroundColor: AppColors.goldSoft,
        child: Icon(
          _filtersVisible ? Icons.close : Icons.tune,
          color: Colors.black,
        ),
      ),
    );
  }

  List<Widget> _buildElementalWeaknessOverlays(Monster monster) {
    // Debug: imprimir las debilidades del monstruo
    print('Monster: ${monster.name}');
    print('Total weaknesses: ${monster.weaknesses.length}');
    monster.weaknesses.forEach((w) {
      print('  - Kind: ${w.kind}, Element: ${w.element}, Level: ${w.level}');
    });

    // Mostrar todas las debilidades elementales, no solo las de nivel 2+
    final elementalWeaknesses = monster.weaknesses.where((w) {
      return w.kind == 'element';
    }).toList();

    print('Elemental weaknesses found: ${elementalWeaknesses.length}');

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

  Color _getElementColor(String element) {
    switch (element) {
      case 'fire':
        return Colors.red;
      case 'water':
        return Colors.blue;
      case 'ice':
        return Colors.lightBlue;
      case 'thunder':
        return Colors.yellow;
      case 'dragon':
        return Colors.purple;
      case 'poison':
        return Colors.green;
      case 'sleep':
        return Colors.indigo;
      case 'paralysis':
        return Colors.orange;
      case 'blast':
        return Colors.deepOrange;
      case 'bleeding':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildWeaknessesSection(Monster monster) {
    final weaknessesLevel1 = monster.weaknesses.where((w) {
      return (w.kind == 'element' || w.kind == 'status') && w.level == 1;
    }).toList();

    if (weaknessesLevel1.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Weaknesses:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: weaknessesLevel1.map((w) {
            if (w.kind == 'element') {
              return Image.asset(
                'assets/imgs/elements/${w.element!.toLowerCase()}.webp',
                width: 16,
                height: 16,
              );
            } else if (w.kind == 'status') {
              return Image.asset(
                'assets/imgs/elements/${w.status!.toLowerCase()}.webp',
                width: 16,
                height: 16,
              );
            } else {
              return const SizedBox.shrink();
            }
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildLocationsSection(Monster monster) {
    if (monster.locations.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Locations:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: monster.locations.map((loc) {
            final name = (loc is Location) ? loc.name : '-';
            return Cchip(
              itemName: name,
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
}
