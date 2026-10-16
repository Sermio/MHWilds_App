import 'package:mhwilds_app/api/skills_api.dart';
import 'package:mhwilds_app/models/skills.dart';
import 'package:mhwilds_app/providers/cached_list_provider.dart';
import 'package:mhwilds_app/utils/load_state.dart';

class SkillsProvider extends CachedListProvider<Skills> {
  SkillsProvider({super.api});

  List<Skills> _allSkills = [];
  List<Skills> _filteredSkills = [];

  String _nameFilter = '';
  String? _kindFilter;

  List<Skills> get allSkills => _allSkills;
  List<Skills> get skills => _filteredSkills;

  /// Skills por id en el orden de [ids]: de memoria si ya están cargadas todas,
  /// si no, con una sola petición a la API.
  Future<List<Skills>> skillsByIds(Set<int> ids) {
    final byId = {for (final s in _allSkills) s.id: s};
    if (ids.every(byId.containsKey)) {
      return Future.value([for (final id in ids) byId[id]!]);
    }
    return SkillsApi.fetchSkillsByIds(ids);
  }

  Future<void> fetchSkills() => fetch();

  @override
  Stream<Data<List<Skills>>> watch({required bool force}) =>
      SkillsApi.watchSkills(force: force, api: api);

  @override
  void onData(List<Skills> data) {
    _allSkills = data;
    _allSkills
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    // Conserva los filtros activos si llegan datos nuevos.
    _filter();
  }

  @override
  void onReset() {
    _allSkills = [];
    _filteredSkills = [];
    _nameFilter = '';
    _kindFilter = null;
  }

  void applyFilters({String? name, String? kind}) {
    _nameFilter = name ?? '';
    _kindFilter = kind;
    _filter();
    notifyListeners();
  }

  void _filter() {
    _filteredSkills = _allSkills.where((skill) {
      final matchesName = _nameFilter.isEmpty ||
          skill.name.toLowerCase().contains(_nameFilter.toLowerCase());

      final matchesKind = _kindFilter == null || skill.kind == _kindFilter;

      return matchesName && matchesKind;
    }).toList();
  }

  void clearFilters() {
    _nameFilter = '';
    _kindFilter = null;
    _filteredSkills = List.from(_allSkills);
    notifyListeners();
  }
}
