import 'package:flutter/material.dart';
import 'package:mhwilds_app/api/monsters_api.dart';
import 'package:mhwilds_app/models/monster.dart';

class MonstersProvider with ChangeNotifier {
  List<Monster> _monsters = [];
  List<Monster> _filteredMonsters = [];
  bool _isLoading = false;
  List<String> _selectedLocations = [];
  bool _hasLocationFilter = false;

  List<Monster> get allMonsters => _monsters;
  bool get isLoading => _isLoading;
  List<Monster> get filteredMonsters => _filteredMonsters;
  bool get hasData => _monsters.isNotEmpty;

  Future<void> fetchMonsters() async {
    if (_monsters.isNotEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      _monsters = await MonstersApi.fetchMonsters();
      _filteredMonsters = List.from(_monsters);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    _isLoading = false;
    notifyListeners();
  }

  void applyFilters({String? name, String? species, List<String>? locations}) {
    _selectedLocations = locations ?? [];
    _hasLocationFilter = _selectedLocations.isNotEmpty;

    _filteredMonsters = _monsters.where((monster) {
      bool matchesName = name == null ||
          monster.name.toLowerCase().contains(name.toLowerCase());
      bool matchesSpecies = species == null ||
          monster.species.toLowerCase().contains(species.toLowerCase());

      bool matchesLocation = _hasLocationFilter
          ? monster.locations.any((location) {
              return _selectedLocations.any((loc) =>
                  location.name.toLowerCase().contains(loc.toLowerCase()));
            })
          : true;

      return matchesName && matchesSpecies && matchesLocation;
    }).toList();

    notifyListeners();
  }

  void clearFilters() {
    _filteredMonsters = _monsters;
    _selectedLocations.clear();
    _hasLocationFilter = false;
    notifyListeners();
  }
}
