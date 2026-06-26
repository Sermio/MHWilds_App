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

  /// Invalida la caché para forzar nueva petición (p. ej. al cambiar idioma).
  void invalidate() {
    _allAmulets = [];
    _filteredAmulets = [];
    _nameFilter = '';
    _rarityFilter = null;
    notifyListeners();
  }

  Future<void> fetchAmulets() async {
    if (_allAmulets.isNotEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final rawAmulets = await AmuletsApi.fetchAmulets();
      final List<Amulet> flattened = [];
      for (final amulet in rawAmulets) {
        for (final rank in amulet.ranks) {
          flattened.add(Amulet(
            id: rank.id, // Usar el ID del rank como ID del amuleto
            gameId: amulet.gameId,
            ranks: [rank], // Solo este rank específico
          ));
        }
      }
      _allAmulets = flattened;

      _allAmulets.sort((a, b) {
        final aRank = a.ranks.isNotEmpty ? a.ranks.first : null;
        final bRank = b.ranks.isNotEmpty ? b.ranks.first : null;
        final aRarity = aRank?.rarity ?? 0;
        final bRarity = bRank?.rarity ?? 0;
        final rarityComp = bRarity.compareTo(aRarity);
        if (rarityComp != 0) return rarityComp;
        final aName = aRank?.name ?? '';
        final bName = bRank?.name ?? '';
        return aName.toLowerCase().compareTo(bName.toLowerCase());
      });

      _filteredAmulets = List.from(_allAmulets);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    _isLoading = false;
    notifyListeners();
  }

  void applyFilters({String? name, int? rarity}) {
    _nameFilter = name ?? '';
    _rarityFilter = rarity;

    if (_allAmulets.isEmpty) {
      return;
    }

    _filteredAmulets = _allAmulets.where((amulet) {
      final rank = amulet.ranks.isNotEmpty ? amulet.ranks.first : null;
      if (rank == null) return false;

      // Filtro por nombre
      final nameMatches = _nameFilter.isEmpty ||
          rank.name.toLowerCase().contains(_nameFilter.toLowerCase());

      // Filtro por rarity
      final rarityMatches =
          _rarityFilter == null || rank.rarity == _rarityFilter;

      return nameMatches && rarityMatches;
    }).toList();

    _filteredAmulets.sort((a, b) {
      final aRank = a.ranks.isNotEmpty ? a.ranks.first : null;
      final bRank = b.ranks.isNotEmpty ? b.ranks.first : null;
      final aRarity = aRank?.rarity ?? 0;
      final bRarity = bRank?.rarity ?? 0;
      final rarityComp = bRarity.compareTo(aRarity);
      if (rarityComp != 0) return rarityComp;
      final aName = aRank?.name ?? '';
      final bName = bRank?.name ?? '';
      return aName.toLowerCase().compareTo(bName.toLowerCase());
    });

    notifyListeners();
  }

  void clearFilters() {
    _nameFilter = '';
    _rarityFilter = null;
    _filteredAmulets = List.from(_allAmulets);
    notifyListeners();
  }
}
