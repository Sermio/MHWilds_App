import 'package:mhwilds_app/api/armor_sets_api.dart';
import 'package:mhwilds_app/models/armor_set.dart';
import 'package:mhwilds_app/providers/cached_list_provider.dart';
import 'package:mhwilds_app/utils/load_state.dart';

class ArmorSetProvider extends CachedListProvider<ArmorSet> {
  ArmorSetProvider({super.api});

  List<ArmorSet> _allArmorSets = [];
  List<ArmorSet> _originalArmorSets = [];
  List<ArmorSet> _filteredArmorSets = [];

  String _nameFilter = '';
  String? _kindFilter;
  int? _rarityFilter;

  List<ArmorSet> get armorSets => _filteredArmorSets;

  Future<void> fetchArmorSets() => fetch();

  @override
  Stream<Data<List<ArmorSet>>> watch({required bool force}) =>
      ArmorsApi.watchArmorSets(force: force, api: api);

  @override
  void onData(List<ArmorSet> data) {
    _allArmorSets = data;
    _allArmorSets.sort((a, b) {
      final aRarity = a.pieces.isNotEmpty ? a.pieces.first.rarity : 0;
      final bRarity = b.pieces.isNotEmpty ? b.pieces.first.rarity : 0;
      final rarityComp = bRarity.compareTo(aRarity);
      if (rarityComp != 0) return rarityComp;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    _originalArmorSets = List.from(_allArmorSets);
    // Conserva los filtros activos si llegan datos nuevos.
    _filter();
  }

  @override
  void onReset() {
    _allArmorSets = [];
    _originalArmorSets = [];
    _filteredArmorSets = [];
    _nameFilter = '';
    _kindFilter = null;
    _rarityFilter = null;
  }

  void applyFilters({String? name, String? kind, int? rarity}) {
    _nameFilter = name ?? '';
    _kindFilter = kind;
    _rarityFilter = rarity;
    _filter();
    notifyListeners();
  }

  void _filter() {
    if (_nameFilter.isEmpty && _kindFilter == null && _rarityFilter == null) {
      _filteredArmorSets = List.from(_allArmorSets);
    } else {
      _filteredArmorSets = _allArmorSets
          .map((set) {
            final matchesName = _nameFilter.isEmpty ||
                set.name.toLowerCase().contains(_nameFilter.toLowerCase());

            final filteredPieces = set.pieces.where((piece) {
              final matchesKind =
                  _kindFilter == null || piece.kind == _kindFilter;
              final matchesRarity =
                  _rarityFilter == null || piece.rarity == _rarityFilter;
              return matchesKind && matchesRarity;
            }).toList();

            if (matchesName && filteredPieces.isNotEmpty) {
              return ArmorSet(
                id: set.id,
                name: set.name,
                gameId: set.gameId,
                groupBonusSkill: set.groupBonusSkill,
                setBonusSkill: set.setBonusSkill,
                pieces: filteredPieces,
              );
            } else {
              return null;
            }
          })
          .whereType<ArmorSet>()
          .toList();
    }
  }

  void clearFilters() {
    _nameFilter = '';
    _kindFilter = null;
    _rarityFilter = null;

    _filteredArmorSets = List.from(_originalArmorSets);

    notifyListeners();
  }
}
