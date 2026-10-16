import 'package:mhwilds_app/api/items_api.dart';
import 'package:mhwilds_app/models/item.dart';
import 'package:mhwilds_app/providers/cached_list_provider.dart';
import 'package:mhwilds_app/utils/load_state.dart';

class ItemsProvider extends CachedListProvider<Item> {
  ItemsProvider({super.api});

  List<Item> _allItems = [];
  List<Item> _filteredItems = [];

  String _nameFilter = '';
  int? _rarityFilter;

  List<Item> get items => _filteredItems;
  List<Item> get allItems => _allItems;

  Future<void> fetchItems() => fetch();

  @override
  Stream<Data<List<Item>>> watch({required bool force}) =>
      ItemsApi.watchItems(force: force, api: api);

  @override
  void onData(List<Item> data) {
    _allItems = data;
    _allItems.sort((a, b) {
      final rarityCompare = b.rarity.compareTo(a.rarity);
      if (rarityCompare != 0) return rarityCompare;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    // Conserva los filtros activos si llegan datos nuevos.
    _filter();
  }

  @override
  void onReset() {
    _allItems = [];
    _filteredItems = [];
    _nameFilter = '';
    _rarityFilter = null;
  }

  void applyFilters({String? name, int? rarity}) {
    _nameFilter = name ?? '';
    _rarityFilter = rarity;
    _filter();
    notifyListeners();
  }

  void _filter() {
    _filteredItems = _allItems.where((item) {
      final matchesName = _nameFilter.isEmpty ||
          item.name.toLowerCase().contains(_nameFilter.toLowerCase());

      final matchesRarity =
          _rarityFilter == null || item.rarity == _rarityFilter;

      return matchesName && matchesRarity;
    }).toList();
  }

  void clearFilters() {
    _nameFilter = '';
    _rarityFilter = null;
    _filteredItems = List.from(_allItems);
    notifyListeners();
  }
}
