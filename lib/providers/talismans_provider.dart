import 'package:mhwilds_app/api/talismans_api.dart';
import 'package:mhwilds_app/models/talisman.dart';
import 'package:mhwilds_app/providers/cached_list_provider.dart';
import 'package:mhwilds_app/utils/load_state.dart';

class TalismansProvider extends CachedListProvider<Amulet> {
  TalismansProvider({super.api});

  List<Amulet> _allAmulets = [];
  List<Amulet> _filteredAmulets = [];

  String _nameFilter = '';
  int? _rarityFilter;

  List<Amulet> get filteredAmulets => _filteredAmulets;

  Future<void> fetchAmulets() => fetch();

  @override
  Stream<Data<List<Amulet>>> watch({required bool force}) =>
      AmuletsApi.watchAmulets(force: force, api: api);

  @override
  void onData(List<Amulet> data) {
    // Un talismán por rango: cada rank pasa a ser una entrada de la lista.
    _allAmulets = [
      for (final amulet in data)
        for (final rank in amulet.ranks)
          Amulet(
            id: rank.id, // Usar el ID del rank como ID del amuleto
            gameId: amulet.gameId,
            ranks: [rank], // Solo este rank específico
          )
    ];
    // Conserva los filtros activos si llegan datos nuevos.
    _filter();
  }

  @override
  void onReset() {
    _allAmulets = [];
    _filteredAmulets = [];
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
    _filteredAmulets = _allAmulets.where((amulet) {
      final rank = amulet.ranks.isNotEmpty ? amulet.ranks.first : null;
      if (rank == null) return false;

      // Filtro por nombre
      final nameMatches = _nameFilter.isEmpty ||
          rank.name.toLowerCase().contains(_nameFilter.toLowerCase());

      // Filtro por rarity
      final rarityMatches =
          _rarityFilter == null || rank.rarity == _rarityFilter;

      return nameMatches && rarityMatches;
    }).toList();

    _filteredAmulets.sort((a, b) {
      final aRank = a.ranks.isNotEmpty ? a.ranks.first : null;
      final bRank = b.ranks.isNotEmpty ? b.ranks.first : null;
      final aRarity = aRank?.rarity ?? 0;
      final bRarity = bRank?.rarity ?? 0;
      final rarityComp = bRarity.compareTo(aRarity);
      if (rarityComp != 0) return rarityComp;
      final aName = aRank?.name ?? '';
      final bName = bRank?.name ?? '';
      return aName.toLowerCase().compareTo(bName.toLowerCase());
    });
  }

  void clearFilters() {
    _nameFilter = '';
    _rarityFilter = null;
    _filter();
    notifyListeners();
  }
}
