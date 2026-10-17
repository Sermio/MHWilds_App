import 'package:mhwilds_app/api/skills_api.dart';
import 'package:mhwilds_app/models/skills.dart';
import 'package:mhwilds_app/providers/catalog_provider.dart';
import 'package:mhwilds_app/providers/filters/skill_filter.dart';
import 'package:mhwilds_app/utils/load_state.dart';

class SkillsProvider extends CatalogProvider<Skills, SkillFilter> {
  SkillsProvider({super.api}) : super(const SkillFilter());

  List<Skills> get allSkills => all;
  List<Skills> get skills => visible;

  /// Skills por id en el orden de [ids]: de memoria si ya están cargadas todas,
  /// si no, con una sola petición a la API.
  Future<List<Skills>> skillsByIds(Set<int> ids) {
    final byId = {for (final s in all) s.id: s};
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
  List<Skills> prepare(List<Skills> data) => data
    ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

  @override
  List<Skills> applyFilter(List<Skills> items, SkillFilter filter) =>
      filterSkills(items, filter);
}
