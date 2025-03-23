import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mhwilds_app/data/monsters.dart';
import 'package:mhwilds_app/models/monster.dart';
import 'package:mhwilds_app/utils/colors.dart';
import 'package:mhwilds_app/utils/utils.dart';
import 'package:mhwilds_app/widgets/c_card.dart';

class MonstersList extends StatefulWidget {
  const MonstersList({super.key});

  @override
  _MonsterScreenState createState() => _MonsterScreenState();
}

class _MonsterScreenState extends State<MonstersList> {
  final TextEditingController _searchNameController = TextEditingController();
  final TextEditingController _searchSpeciesController =
      TextEditingController();
  final TextEditingController _searchLocationController =
      TextEditingController();

  String _searchNameQuery = '';
  String _searchSpeciesQuery = '';
  List<String> _selectedLocations = [];

  bool _filtersVisible = false;

  void _toggleFiltersVisibility() {
    setState(() {
      _filtersVisible = !_filtersVisible;
    });
  }

  void _resetFilters() {
    setState(() {
      _searchNameQuery = '';
      _searchSpeciesQuery = '';
      _selectedLocations = [];

      _searchNameController.clear();
      _searchSpeciesController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> filteredMonsterKeys = monsters.keys.where((monsterKey) {
      Map<String, dynamic> monsterMap = monsters[monsterKey]!;
      Monster monster = Monster.fromMap(monsterMap);

      bool matchesName = monster.monsterName
          .toLowerCase()
          .contains(_searchNameQuery.toLowerCase());

      bool matchesSpecies = monster.monsterSpecies
          .toLowerCase()
          .contains(_searchSpeciesQuery.toLowerCase());

      bool matchesLocation = _selectedLocations.isEmpty ||
          (monster.locations != null &&
              monster.locations!
                  .any((location) => _selectedLocations.contains(location)));

      return matchesName && matchesSpecies && matchesLocation;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
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
                },
                decoration: const InputDecoration(
                  labelText: 'Search by Name',
                  prefixIcon: Icon(
                    Icons.search,
                  ),
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
                },
                decoration: const InputDecoration(
                  labelText: 'Search by Specie',
                  prefixIcon: Icon(
                    Icons.search,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 10.0,
                    children: [
                      "Windward Plains",
                      "Scarlet Forest",
                      "Oilwell Basin",
                      "Iceshard Cliffs",
                      "Ruins of Wyveria",
                    ].map((location) {
                      return FilterChip(
                        label: Text(location),
                        labelStyle: const TextStyle(color: Colors.black),
                        backgroundColor: zoneBackgroundColor(location),
                        selected: _selectedLocations.contains(location),
                        onSelected: (isSelected) {
                          setState(() {
                            if (isSelected) {
                              _selectedLocations.add(location);
                            } else {
                              _selectedLocations.remove(location);
                            }
                          });
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
            const Divider(
              color: Colors.black,
            )
          ],
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredMonsterKeys.length,
              itemBuilder: (context, index) {
                String monsterKey = filteredMonsterKeys[index];

                Map<String, dynamic> monsterMap = monsters[monsterKey]!;
                Monster monster = Monster.fromMap(monsterMap);

                return BounceInLeft(
                  duration: const Duration(milliseconds: 900),
                  delay: Duration(milliseconds: index * 5),
                  child: Ccard(
                    bodyOnTop: false,
                    leading: Hero(
                      tag: monster.monsterName,
                      child: Image.asset(
                          'assets/imgs/monster_icons/${monster.monsterName.toLowerCase().replaceAll(' ', '_')}.png'),
                    ),
                    cardData: monster,
                    cardTitle: monster.monsterName ?? "Unknown",
                    cardSubtitle1Label: "Species: ",
                    // cardSubtitle2Label: "Locations: ",
                    cardSubtitle1: monster.monsterSpecies ?? "Unknown",
                    // cardSubtitle2: monster.locations?.join(", ") ?? "Unknown",
                    cardBody: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Locations: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Flexible(
                          child: Text(
                            monster.locations
                                    ?.join(", ")
                                    .replaceAll(', ', '\n') ??
                                "Unknown",
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: BounceInRight(
        delay: const Duration(milliseconds: 500),
        child: FloatingActionButton(
          onPressed: _toggleFiltersVisibility,
          child: Icon(
            _filtersVisible ? Icons.close : Icons.search,
          ),
        ),
      ),
    );
  }
}
