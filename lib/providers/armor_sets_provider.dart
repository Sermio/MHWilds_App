import 'package:mhwilds_app/api/armor_sets_api.dart';
import 'package:mhwilds_app/models/armor_set.dart';
import 'package:mhwilds_app/providers/catalog_provider.dart';
import 'package:mhwilds_app/providers/filters/armor_set_filter.dart';
import 'package:mhwilds_app/utils/load_state.dart';

class ArmorSetProvider extends CatalogProvider<ArmorSet, ArmorSetFilter> {
  ArmorSetProvider({super.api}) : super(const ArmorSetFilter());

  List<ArmorSet> get armorSets => visible;

  Future<void> fetchArmorSets() => fetch();

  @override
  Stream<Data<List<ArmorSet>>> watch({required bool force}) =>
      ArmorsApi.watchArmorSets(force: force, api: api);

  @override
  List<ArmorSet> prepare(List<ArmorSet> data) => data
    ..sort((a, b) {
      final aRarity = a.pieces.isNotEmpty ? a.pieces.first.rarity : 0;
      final bRarity = b.pieces.isNotEmpty ? b.pieces.first.rarity : 0;
      final rarityComp = bRarity.compareTo(aRarity);
      if (rarityComp != 0) return rarityComp;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

  @override
  List<ArmorSet> applyFilter(List<ArmorSet> items, ArmorSetFilter filter) =>
      filterArmorSets(items, filter);
}
