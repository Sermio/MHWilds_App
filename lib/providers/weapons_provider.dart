import 'package:flutter/material.dart';
import 'package:mhwilds_app/api/weapons_api.dart';
import 'package:mhwilds_app/models/weapon.dart';

class WeaponsProvider with ChangeNotifier {
  List<Weapon> _allWeapons = [];
  List<Weapon> _originalWeapons = [];
  List<Weapon> _filteredWeapons = [];
  bool _isLoading = false;

  String _nameFilter = '';
  String? _kindFilter;
  int? _rarityFilter;

  List<Weapon> get weapons => _filteredWeapons;
  bool get isLoading => _isLoading;
  bool get hasData => _allWeapons.isNotEmpty;

  Future<void> fetchWeapons() async {
    if (_allWeapons.isNotEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      _allWeapons = await WeaponsApi.fetchWeapons();

      // Debug: Ver cuántas weapons de cada kind tenemos
      final kindCounts = <String, int>{};
      for (final weapon in _allWeapons) {
        kindCounts[weapon.kind] = (kindCounts[weapon.kind] ?? 0) + 1;
      }

      // Debug: Ver específicamente switch-axe weapons
      final switchAxeWeapons =
          _allWeapons.where((w) => w.kind == 'switch-axe').toList();

      _originalWeapons = List.from(_allWeapons);
      _filteredWeapons = List.from(_allWeapons);
    } catch (e) {
      print('WeaponsProvider: Error fetching weapons: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void applyFilters({String? name, String? kind, int? rarity}) {
    _nameFilter = name ?? _nameFilter;
    _kindFilter = kind ?? _kindFilter;
    _rarityFilter = rarity ?? _rarityFilter;

    // Debug específico para switch-axe
    if (_kindFilter == 'switch-axe') {
      final switchAxeWeapons =
          _allWeapons.where((w) => w.kind == 'switch-axe').toList();

      for (final weapon in switchAxeWeapons) {}
    }

    if (_nameFilter.isEmpty && _kindFilter == null && _rarityFilter == null) {
      _filteredWeapons = List.from(_allWeapons);
    } else {
      _filteredWeapons = _allWeapons.where((weapon) {
        final matchesName = _nameFilter.isEmpty ||
            weapon.name.toLowerCase().contains(_nameFilter.toLowerCase());

        final matchesKind = _kindFilter == null || weapon.kind == _kindFilter;

        final matchesRarity =
            _rarityFilter == null || weapon.rarity == _rarityFilter;

        return matchesName && matchesKind && matchesRarity;
      }).toList();
    }

    notifyListeners();
  }

  void clearFilters() {
    _nameFilter = '';
    _kindFilter = null;
    _rarityFilter = null;

    _filteredWeapons = List.from(_originalWeapons);

    notifyListeners();
  }
}
