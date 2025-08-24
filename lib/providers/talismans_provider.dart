import 'package:flutter/material.dart';
import 'package:mhwilds_app/models/talisman.dart';
import 'package:mhwilds_app/api/talismans_api.dart';

class TalismansProvider with ChangeNotifier {
  List<Amulet> _allAmulets = [];
  List<Amulet> _filteredAmulets = [];
  bool _isLoading = false;

  String _nameFilter = '';
  int? _rarityFilter;

  List<Amulet> get filteredAmulets => _filteredAmulets;
  bool get isLoading => _isLoading;
  bool get hasData => _allAmulets.isNotEmpty;

  Future<void> fetchAmulets() async {
    if (_allAmulets.isNotEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      _allAmulets = await AmuletsApi.fetchAmulets();
      _filteredAmulets = List.from(_allAmulets);
    } catch (e) {}

    _isLoading = false;
    notifyListeners();
  }

  void applyFilters({String? name, int? rarity}) {
    _nameFilter = name ?? _nameFilter;
    _rarityFilter = rarity ?? _rarityFilter;

    if (_allAmulets.isEmpty) {
      return;
    }

    List<AmuletRank> allRanks = [];
    for (var amulet in _allAmulets) {
      allRanks.addAll(amulet.ranks);
    }

    // Filtrar los ranks por nombre y rarity
    List<AmuletRank> filteredRanks = allRanks.where((rank) {
      // Filtro por nombre
      bool nameMatches = _nameFilter.isEmpty ||
          rank.name.toLowerCase().contains(_nameFilter.toLowerCase());

      // Filtro por rarity
      bool rarityMatches =
          _rarityFilter == null || rank.rarity == _rarityFilter;

      return nameMatches && rarityMatches;
    }).toList();

    // Crear amuletos individuales para cada rank filtrado
    _filteredAmulets = filteredRanks.map((rank) {
      return Amulet(
        id: rank.id, // Usar el ID del rank como ID del amuleto
        gameId: -1, // ID temporal
        ranks: [rank], // Solo este rank específico
      );
    }).toList();

    notifyListeners();
  }

  void clearFilters() {
    _nameFilter = '';
    _rarityFilter = null;
    _filteredAmulets = List.from(_allAmulets);
    notifyListeners();
  }
}
