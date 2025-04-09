import 'package:flutter/material.dart';
import 'package:mhwilds_app/models/amulet.dart';
import 'package:mhwilds_app/api/amulets_api.dart'; // Asegúrate de importar la API correcta

class AmuletProvider with ChangeNotifier {
  List<Amulet> _allAmulets = [];
  late List<Amulet> _originalAmulets;
  List<Amulet> _filteredAmulets = [];
  bool _isLoading = false;

  String _nameFilter = '';

  List<Amulet> get filteredAmulets => _filteredAmulets;
  bool get isLoading => _isLoading;
  bool get hasData => _allAmulets.isNotEmpty;

  Future<void> fetchAmulets() async {
    if (_allAmulets.isNotEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      _allAmulets = await AmuletsApi.fetchAmulets();
      _originalAmulets = List.from(_allAmulets);
      _filteredAmulets = List.from(_allAmulets);
    } catch (e) {
      print(e);
    }

    _isLoading = false;
    notifyListeners();
  }

  void applyFilters({String? name}) {
    _nameFilter = name ?? _nameFilter;

    if (_nameFilter.isEmpty) {
      _filteredAmulets = List.from(_allAmulets);
    } else {
      _filteredAmulets = _allAmulets.where((amulet) {
        return amulet.ranks.any((rank) {
          return rank.name.toLowerCase().contains(_nameFilter.toLowerCase());
        });
      }).toList();
    }

    notifyListeners();
  }

  void clearFilters() {
    _nameFilter = '';
    _filteredAmulets = List.from(_allAmulets);
    notifyListeners();
  }
}
