import 'package:mhwilds_app/api/talismans_api.dart';
import 'package:mhwilds_app/models/talisman.dart';
import 'package:mhwilds_app/providers/catalog_provider.dart';
import 'package:mhwilds_app/providers/filters/amulet_filter.dart';
import 'package:mhwilds_app/utils/load_state.dart';

class TalismansProvider extends CatalogProvider<Amulet, AmuletFilter> {
  TalismansProvider({super.api}) : super(const AmuletFilter());

  List<Amulet> get filteredAmulets => visible;

  Future<void> fetchAmulets() => fetch();

  @override
  Stream<Data<List<Amulet>>> watch({required bool force}) =>
      AmuletsApi.watchAmulets(force: force, lang: language, api: api);

  /// Un talismán por rango: cada rank pasa a ser una entrada de la lista.
  @override
  List<Amulet> prepare(List<Amulet> data) => [
        for (final amulet in data)
          for (final rank in amulet.ranks)
            Amulet(
              id: rank.id, // Usar el ID del rank como ID del amuleto
              gameId: amulet.gameId,
              ranks: [rank], // Solo este rank específico
            )
      ];

  @override
  List<Amulet> applyFilter(List<Amulet> items, AmuletFilter filter) =>
      filterAmulets(items, filter);
}
