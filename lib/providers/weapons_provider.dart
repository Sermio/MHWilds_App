import 'package:mhwilds_app/api/weapons_api.dart';
import 'package:mhwilds_app/models/weapon.dart';
import 'package:mhwilds_app/providers/catalog_provider.dart';
import 'package:mhwilds_app/providers/filters/weapon_filter.dart';
import 'package:mhwilds_app/utils/load_state.dart';

class WeaponsProvider extends CatalogProvider<Weapon, WeaponFilter> {
  WeaponsProvider({super.api}) : super(const WeaponFilter());

  List<Weapon> get weapons => visible;

  Future<void> fetchWeapons() => fetch();

  @override
  Stream<Data<List<Weapon>>> watch({required bool force}) =>
      WeaponsApi.watchWeapons(force: force, api: api);

  @override
  List<Weapon> prepare(List<Weapon> data) => data
    ..sort((a, b) {
      final kindComp = a.kind.toLowerCase().compareTo(b.kind.toLowerCase());
      if (kindComp != 0) return kindComp;
      final rarityComp = b.rarity.compareTo(a.rarity);
      if (rarityComp != 0) return rarityComp;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

  @override
  List<Weapon> applyFilter(List<Weapon> items, WeaponFilter filter) =>
      filterWeapons(items, filter);

  Weapon? getWeaponById(int id) {
    for (final w in all) {
      if (w.id == id) return w;
    }
    return null;
  }
}
