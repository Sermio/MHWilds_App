import 'package:mhwilds_app/models/weapon.dart';
import 'package:mhwilds_app/providers/catalog_provider.dart';

class WeaponFilter extends CatalogFilter {
  const WeaponFilter({
    this.name = '',
    this.series = '',
    this.kind,
    this.rarity,
  });

  final String name;
  final String series;
  final String? kind;
  final int? rarity;

  WeaponFilter copyWith({
    String? name,
    String? series,
    String? Function()? kind,
    int? Function()? rarity,
  }) =>
      WeaponFilter(
        name: name ?? this.name,
        series: series ?? this.series,
        kind: kind != null ? kind() : this.kind,
        rarity: rarity != null ? rarity() : this.rarity,
      );

  @override
  List<Object?> get props => [name, series, kind, rarity];
}

List<Weapon> filterWeapons(List<Weapon> weapons, WeaponFilter filter) {
  final name = filter.name.toLowerCase();
  final series = filter.series.toLowerCase();
  return weapons.where((weapon) {
    final matchesName =
        name.isEmpty || weapon.name.toLowerCase().contains(name);
    final matchesSeries = series.isEmpty ||
        (weapon.series != null &&
            weapon.series!.name.toLowerCase().contains(series));
    final matchesKind = filter.kind == null || weapon.kind == filter.kind;
    final matchesRarity =
        filter.rarity == null || weapon.rarity == filter.rarity;
    return matchesName && matchesSeries && matchesKind && matchesRarity;
  }).toList();
}
