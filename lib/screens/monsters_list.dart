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
      body: Column(
        children: [
          if (_filtersVisible) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
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
                decoration: const InputDecoration(
                  labelText: 'Search by Name',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
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
                decoration: const InputDecoration(
                  labelText: 'Search by Species',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: zonesProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 10.0,
                          children: zonesProvider.zones.map((zone) {
                            return FilterChip(
                              label: Text(zone.name!),
                              labelStyle: const TextStyle(color: Colors.black),
                              backgroundColor: zoneBackgroundColor(zone.name!),
                              selected: _selectedLocations.contains(zone.name),
                              onSelected: (isSelected) {
                                setState(() {
                                  if (isSelected) {
                                    _selectedLocations.add(zone.name!);
                                  } else {
                                    _selectedLocations.remove(zone.name);
                                  }
                                });
                                // Apply filter
                                monstersProvider.applyFilters(
                                  name: _searchNameQuery,
                                  species: _searchSpeciesQuery,
                                  locations: _selectedLocations,
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _resetFilters,
                child: const Text('Reset Filters'),
              ),
            ),
            const Divider(color: Colors.black),
          ],
          Expanded(
            child: monstersProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: monsters.length,
                    itemBuilder: (context, index) {
                      var monster = monsters[index];

                      return BounceInLeft(
                        duration: const Duration(milliseconds: 900),
                        delay: Duration(milliseconds: index * 5),
                        child: CustomCard(
                          shadowColor: AppColors.goldSoft,
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
                          title: Row(
                            children: [
                              Hero(
                                tag: monster.name,
                                child: Image.asset(
                                    width: 50,
                                    height: 50,
                                    'assets/imgs/monster_icons/${monster.name.toLowerCase().replaceAll(' ', '_')}.png'),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    monster.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          body: _MonsterBody(monster: monster),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleFiltersVisibility,
        child: Icon(
          _filtersVisible ? Icons.close : Icons.search,
        ),
      ),
    );
  }
}

class _MonsterBody extends StatelessWidget {
  const _MonsterBody({
    required this.monster,
  });

  final Monster monster;

  @override
  Widget build(BuildContext context) {
    final locations = monster.locations;
    final weaknessesLevel1 = monster.weaknesses.where((w) {
      return (w.kind == 'element' || w.kind == 'status') && w.level == 1;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 5,
        ),
        Wrap(
          runSpacing: 5,
          children: [
            Text(monster.description),
            const Text(
              "Species: ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(monster.species),
          ],
        ),
        Wrap(
          runSpacing: 5,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (weaknessesLevel1.isNotEmpty) ...[
              const Text(
                "Weaknesses: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...weaknessesLevel1.map((w) {
                if (w.kind == 'element') {
                  return Image.asset(
                    width: 30,
                    height: 30,
                    'assets/imgs/elements/${w.element!.toLowerCase()}.webp',
                  );
                } else if (w.kind == 'status') {
                  return Image.asset(
                    width: 27,
                    height: 27,
                    'assets/imgs/elements/${w.status!.toLowerCase()}.webp',
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
            ],
          ],
        ),
        if (locations.isNotEmpty) ...[
          // const Text(
          //   "Locations:",
          //   style: TextStyle(fontWeight: FontWeight.bold),
          // ),
          Wrap(
            spacing: 5,
            runSpacing: -5,
            children: [
              ...locations.map((loc) {
                // ignore: unnecessary_type_check
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
              }),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}
