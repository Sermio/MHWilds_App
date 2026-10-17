import 'package:mhwilds_app/api/monsters_api.dart';
import 'package:mhwilds_app/models/monster.dart';
import 'package:mhwilds_app/providers/catalog_provider.dart';
import 'package:mhwilds_app/providers/filters/monster_filter.dart';
import 'package:mhwilds_app/utils/load_state.dart';
import 'package:mhwilds_app/utils/utils.dart';

class MonstersProvider extends CatalogProvider<Monster, MonsterFilter> {
  MonstersProvider({
    super.api,
    Future<Monster> Function(int id)? fetchById,
  })  : _fetchById = fetchById,
        super(const MonsterFilter());

  final Future<Monster> Function(int id)? _fetchById;

  // Nombre normalizado por id, calculado una vez al cargar.
  Map<int, String> _normalizedNames = {};

  /// `/monsters` y `/monsters/{id}` devuelven el mismo JSON, así que el
  /// monstruo del listado vale para el detalle; se pide por id solo si falta.
  Future<Monster> monsterById(int id) {
    for (final m in all) {
      if (m.id == id) return Future.value(m);
    }
    return _fetchById?.call(id) ??
        MonstersApi.fetchMonsterById(id, lang: language);
  }

  List<Monster> get allMonsters => all;
  List<Monster> get filteredMonsters => visible;

  Future<void> fetchMonsters() => fetch();

  @override
  Stream<Data<List<Monster>>> watch({required bool force}) =>
      MonstersApi.watchMonsters(force: force, lang: language, api: api);

  @override
  List<Monster> prepare(List<Monster> data) {
    _normalizedNames = {for (final m in data) m.id: removeDiacritics(m.name)};
    return data;
  }

  @override
  List<Monster> applyFilter(List<Monster> items, MonsterFilter filter) =>
      filterMonsters(items, filter, normalizedNames: _normalizedNames);

  @override
  void onReset() {
    super.onReset();
    _normalizedNames = {};
  }
}
