import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mhwilds_app/data/monsters.dart'; // Asegúrate de que tienes tus monstruos aquí
import 'package:mhwilds_app/models/monster.dart';
import 'package:mhwilds_app/utils/utils.dart';
import 'package:mhwilds_app/widgets/c_card.dart';

class MonsterScreen extends StatefulWidget {
  const MonsterScreen({super.key});

  @override
  _MonsterScreenState createState() => _MonsterScreenState();
}

class _MonsterScreenState extends State<MonsterScreen> {
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
    // Filtrar los monstruos según el texto de búsqueda en cada campo y las ubicaciones seleccionadas
    List<String> filteredMonsterKeys = monsters.keys.where((monsterKey) {
      Map<String, dynamic> monsterMap =
          monsters[monsterKey]!; // Accedemos al Map de Monster
      Monster monster =
          Monster.fromMap(monsterMap); // Convertimos el Map a un objeto Monster

      bool matchesName = monster.monsterName
          .toLowerCase()
          .contains(_searchNameQuery.toLowerCase());

      bool matchesSpecies = monster.monsterSpecie
          .toLowerCase()
          .contains(_searchSpeciesQuery.toLowerCase());

      // Filtrar por ubicación seleccionada
      bool matchesLocation = _selectedLocations.isEmpty ||
          (monster.locations != null &&
              monster.locations!
                  .any((location) => _selectedLocations.contains(location)));

      return matchesName && matchesSpecies && matchesLocation;
    }).toList();

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
                },
                decoration: const InputDecoration(
                  labelText: 'Search by Specie',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
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
            // Botón para resetear los filtros
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

                // Accedemos al Map y lo convertimos en un objeto Monster
                Map<String, dynamic> monsterMap = monsters[monsterKey]!;
                Monster monster = Monster.fromMap(monsterMap);

                return Ccard(
                  leading: FadeIn(
                    child: Image.asset(
                        'assets/imgs/monster_icons/${monster.monsterName.toLowerCase().replaceAll(' ', '_')}.png'),
                  ),
                  cardData: monster, // Ahora pasamos el objeto Monster
                  cardTitle: monster.monsterName ??
                      "Unknown", // Accedemos a los atributos de Monster
                  cardSubtitle1Label: "Specie: ",
                  cardSubtitle2Label: "Locations: ",
                  cardSubtitle1: monster.monsterSpecie ??
                      "Unknown", // Especie del monstruo
                  cardSubtitle2:
                      monster.locations?.join(", ") ?? "Unknown", // Ubicaciones
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
