import 'package:mhwilds_app/api/monsters_api.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/monster.dart';
import 'package:mhwilds_app/providers/cached_list_provider.dart';
import 'package:mhwilds_app/utils/load_state.dart';
import 'package:mhwilds_app/utils/utils.dart';

class MonstersProvider extends CachedListProvider<Monster> {
  List<Monster> _monsters = [];
  List<Monster> _filteredMonsters = [];
  // Filtros activos, para reaplicarlos cuando llegan datos nuevos.
  String? _name;
  String? _species;
  String? _rank;
  List<String> _selectedLocations = [];
  // Nombre normalizado por id, calculado una vez al cargar.
  Map<int, String> _normalizedNames = {};

  MonstersProvider({
    super.api,
    Future<Monster> Function(int id)? fetchById,
  }) : _fetchById = fetchById ?? MonstersApi.fetchMonsterById;

  final Future<Monster> Function(int id) _fetchById;

  /// `/monsters` y `/monsters/{id}` devuelven el mismo JSON, así que el
  /// monstruo del listado vale para el detalle; se pide por id solo si falta.
  Future<Monster> monsterById(int id) {
    for (final m in _monsters) {
      if (m.id == id) return Future.value(m);
    }
    return _fetchById(id);
  }

  List<Monster> get allMonsters => _monsters;
  List<Monster> get filteredMonsters => _filteredMonsters;

  Future<void> fetchMonsters() => fetch();

  @override
  Stream<Data<List<Monster>>> watch({required bool force}) =>
      MonstersApi.watchMonsters(force: force, api: api);

  @override
  void onData(List<Monster> data) {
    _monsters = data;
    _normalizedNames = {
      for (final m in _monsters) m.id: removeDiacritics(m.name)
    };
    _filter();
  }

  @override
  void onReset() {
    _monsters = [];
    _filteredMonsters = [];
    _normalizedNames = {};
    _name = _species = _rank = null;
    _selectedLocations = [];
  }

  void applyFilters(
      {String? name,
      String? species,
      String? rank,
      List<String>? locations,
      required AppLocalizations l10n}) {
    _name = name;
    _species = species;
    _rank = rank;
    _selectedLocations = locations ?? [];
    _filter();
    notifyListeners();
  }

  void _filter() {
    final searchName = removeDiacritics(_name ?? '');
    _filteredMonsters = _monsters.where((monster) {
      final bool matchesName = _name == null ||
          (_normalizedNames[monster.id] ?? '').contains(searchName);

      final bool matchesSpecies =
          _species == null || monster.species == _species;

      final bool matchesRank =
          _rank == null || monster.availableRanks.contains(_rank);

      final bool matchesLocation = _selectedLocations.isEmpty ||
          monster.locations.any((location) {
            return _selectedLocations.any((loc) =>
                location.name.toLowerCase().contains(loc.toLowerCase()));
          });

      return matchesName && matchesSpecies && matchesRank && matchesLocation;
    }).toList();
  }

  void clearFilters() {
    _name = _species = _rank = null;
    _selectedLocations = [];
    _filteredMonsters = _monsters;
    notifyListeners();
  }
}
