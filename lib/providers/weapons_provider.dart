import 'package:mhwilds_app/api/weapons_api.dart';
import 'package:mhwilds_app/models/weapon.dart';
import 'package:mhwilds_app/providers/cached_list_provider.dart';
import 'package:mhwilds_app/utils/load_state.dart';

class WeaponsProvider extends CachedListProvider<Weapon> {
  WeaponsProvider({super.api});

  List<Weapon> _allWeapons = [];
  List<Weapon> _originalWeapons = [];
  List<Weapon> _filteredWeapons = [];

  String _nameFilter = '';
  String _seriesFilter = '';
  String? _kindFilter;
  int? _rarityFilter;

  List<Weapon> get weapons => _filteredWeapons;

  Future<void> fetchWeapons() => fetch();

  @override
  Stream<Data<List<Weapon>>> watch({required bool force}) =>
      WeaponsApi.watchWeapons(force: force, api: api);

  @override
  void onData(List<Weapon> data) {
    _allWeapons = data;
    _allWeapons.sort((a, b) {
      final kindComp = a.kind.toLowerCase().compareTo(b.kind.toLowerCase());
      if (kindComp != 0) return kindComp;
      final rarityComp = b.rarity.compareTo(a.rarity);
      if (rarityComp != 0) return rarityComp;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    _originalWeapons = List.from(_allWeapons);
    // Conserva los filtros activos si llegan datos nuevos.
    _filter();
  }

  @override
  void onReset() {
    _allWeapons = [];
    _originalWeapons = [];
    _filteredWeapons = [];
    _nameFilter = '';
    _seriesFilter = '';
    _kindFilter = null;
    _rarityFilter = null;
  }

  void applyFilters({String? name, String? series, String? kind, int? rarity}) {
    _nameFilter = name ?? '';
    _seriesFilter = series ?? '';
    _kindFilter = kind;
    _rarityFilter = rarity;
    _filter();
    notifyListeners();
  }

  void _filter() {
    if (_nameFilter.isEmpty &&
        _seriesFilter.isEmpty &&
        _kindFilter == null &&
        _rarityFilter == null) {
      _filteredWeapons = List.from(_allWeapons);
    } else {
      _filteredWeapons = _allWeapons.where((weapon) {
        final matchesName = _nameFilter.isEmpty ||
            weapon.name.toLowerCase().contains(_nameFilter.toLowerCase());

        final matchesSeries = _seriesFilter.isEmpty ||
            (weapon.series != null &&
                weapon.series!.name
                    .toLowerCase()
                    .contains(_seriesFilter.toLowerCase()));

        final matchesKind = _kindFilter == null || weapon.kind == _kindFilter;

        final matchesRarity =
            _rarityFilter == null || weapon.rarity == _rarityFilter;

        return matchesName && matchesSeries && matchesKind && matchesRarity;
      }).toList();
    }
  }

  void clearFilters() {
    _nameFilter = '';
    _seriesFilter = '';
    _kindFilter = null;
    _rarityFilter = null;

    _filteredWeapons = List.from(_originalWeapons);

    notifyListeners();
  }

  Weapon? getWeaponById(int id) {
    try {
      return _allWeapons.firstWhere((w) => w.id == id);
    } catch (e) {
      return null;
    }
  }
}
