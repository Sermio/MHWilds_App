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

  List<ArmorSet> get armorSets => _filteredArmorSets;
  bool get isLoading => _isLoading;
  bool get hasData => _allArmorSets.isNotEmpty;

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

  void applyFilters({String? name, String? kind}) {
    _nameFilter = name ?? _nameFilter;
    _kindFilter = kind ?? _kindFilter;

    if (_nameFilter.isEmpty && _kindFilter == null) {
      _filteredArmorSets = List.from(_allArmorSets);
    } else {
      _filteredArmorSets = _allArmorSets
          .map((set) {
            final matchesName = _nameFilter.isEmpty ||
                set.name.toLowerCase().contains(_nameFilter.toLowerCase());

            final filteredPieces = set.pieces.where((piece) {
              final matchesKind =
                  _kindFilter == null || piece.kind == _kindFilter;
              return matchesKind;
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

    _filteredArmorSets = List.from(_originalArmorSets);

    notifyListeners();
  }
}
