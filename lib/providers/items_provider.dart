import 'package:flutter/material.dart';
import 'package:mhwilds_app/api/items_api.dart';
import 'package:mhwilds_app/models/item.dart';

class ItemsProvider with ChangeNotifier {
  List<Item> _allItems = [];
  List<Item> _filteredItems = [];
  bool _isLoading = false;

  String _nameFilter = '';
  int _rarityFilter = -1;

  List<Item> get items => _filteredItems;
  bool get isLoading => _isLoading;
  bool get hasData => _allItems.isNotEmpty;

  /// Invalida la caché para forzar nueva petición (p. ej. al cambiar idioma).
  void invalidate() {
    _allItems = [];
    _filteredItems = [];
    _nameFilter = '';
    _rarityFilter = -1;
    notifyListeners();
  }

  Future<void> fetchItems() async {
    if (_allItems.isNotEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      _allItems = await ItemsApi.fetchItems();
      _filteredItems = List.from(_allItems);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    _isLoading = false;
    notifyListeners();
  }

  void applyFilters({String? name, int? rarity}) {
    _nameFilter = name ?? _nameFilter;
    _rarityFilter = rarity ?? _rarityFilter;

    _filteredItems = _allItems.where((item) {
      final matchesName = _nameFilter.isEmpty ||
          item.name.toLowerCase().contains(_nameFilter.toLowerCase());

      final matchesRarity = _rarityFilter == -1 || item.rarity == _rarityFilter;

      return matchesName && matchesRarity;
    }).toList();

    notifyListeners();
  }

  void clearFilters() {
    _nameFilter = '';
    _rarityFilter = -1;
    _filteredItems = List.from(_allItems);
    notifyListeners();
  }
}
