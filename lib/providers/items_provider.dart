import 'package:flutter/material.dart';
import 'package:mhwilds_app/api/items_api.dart';
import 'package:mhwilds_app/models/item.dart';

class ItemsProvider with ChangeNotifier {
  List<Item> _allItems = [];
  List<Item> _filteredItems = [];
  bool _isLoading = false;

  String _nameFilter = '';
  int? _rarityFilter;

  List<Item> get items => _filteredItems;
  List<Item> get allItems => _allItems;
  bool get isLoading => _isLoading;
  bool get hasData => _allItems.isNotEmpty;

  /// Invalida la caché para forzar nueva petición (p. ej. al cambiar idioma).
  void invalidate() {
    _allItems = [];
    _filteredItems = [];
    _nameFilter = '';
    _rarityFilter = null;
    notifyListeners();
  }

  Future<void> fetchItems() async {
    if (_allItems.isNotEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      _allItems = await ItemsApi.fetchItems();
      _allItems.sort((a, b) {
        final rarityCompare = b.rarity.compareTo(a.rarity);
        if (rarityCompare != 0) return rarityCompare;
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
      _filteredItems = List.from(_allItems);
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

    _filteredItems = _allItems.where((item) {
      final matchesName = _nameFilter.isEmpty ||
          item.name.toLowerCase().contains(_nameFilter.toLowerCase());

      final matchesRarity = _rarityFilter == null || item.rarity == _rarityFilter;

      return matchesName && matchesRarity;
    }).toList();

    notifyListeners();
  }

  void clearFilters() {
    _nameFilter = '';
    _rarityFilter = null;
    _filteredItems = List.from(_allItems);
    notifyListeners();
  }
}
