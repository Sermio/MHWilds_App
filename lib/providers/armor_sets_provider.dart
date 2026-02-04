import 'package:flutter/material.dart';
import 'package:mhwilds_app/api/armor_sets_api.dart';
import 'package:mhwilds_app/models/armor_set.dart';

class ArmorSetProvider with ChangeNotifier {
  List<ArmorSet> _allArmorSets = [];
  List<ArmorSet> _originalArmorSets = [];
  List<ArmorSet> _filteredArmorSets = [];
  bool _isLoading = false;

  String _nameFilter = '';
  String? _kindFilter;
  int? _rarityFilter;

  List<ArmorSet> get armorSets => _filteredArmorSets;
  bool get isLoading => _isLoading;
  bool get hasData => _allArmorSets.isNotEmpty;

  /// Invalida la caché para forzar nueva petición (p. ej. al cambiar idioma).
  void invalidate() {
    _allArmorSets = [];
    _originalArmorSets = [];
    _filteredArmorSets = [];
    _nameFilter = '';
    _kindFilter = null;
    _rarityFilter = null;
    notifyListeners();
  }

  Future<void> fetchArmorSets() async {
    if (_allArmorSets.isNotEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      _allArmorSets = await ArmorsApi.fetchArmorSets();
      _originalArmorSets = List.from(_allArmorSets);
      _filteredArmorSets = List.from(_allArmorSets);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    _isLoading = false;
    notifyListeners();
  }

  void applyFilters({String? name, String? kind, int? rarity}) {
    _nameFilter = name ?? _nameFilter;
    _kindFilter = kind ?? _kindFilter;
    _rarityFilter = rarity ?? _rarityFilter;

    if (_nameFilter.isEmpty && _kindFilter == null && _rarityFilter == null) {
      _filteredArmorSets = List.from(_allArmorSets);
    } else {
      _filteredArmorSets = _allArmorSets
          .map((set) {
            final matchesName = _nameFilter.isEmpty ||
                set.name.toLowerCase().contains(_nameFilter.toLowerCase());

            final filteredPieces = set.pieces.where((piece) {
              final matchesKind =
                  _kindFilter == null || piece.kind == _kindFilter;
              final matchesRarity =
                  _rarityFilter == null || piece.rarity == _rarityFilter;
              return matchesKind && matchesRarity;
            }).toList();

            if (matchesName && filteredPieces.isNotEmpty) {
              return ArmorSet(
                id: set.id,
                name: set.name,
                gameId: set.gameId,
                groupBonus: set.groupBonus,
                bonus: set.bonus,
                pieces: filteredPieces,
              );
            } else {
              return null;
            }
          })
          .whereType<ArmorSet>()
          .toList();
    }

    notifyListeners();
  }

  void clearFilters() {
    _nameFilter = '';
    _kindFilter = null;
    _rarityFilter = null;

    _filteredArmorSets = List.from(_originalArmorSets);

    notifyListeners();
  }
}
