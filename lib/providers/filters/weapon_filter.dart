import 'package:mhwilds_app/models/weapon.dart';
import 'package:mhwilds_app/providers/catalog_provider.dart';
import 'package:mhwilds_app/utils/game_element.dart';

class WeaponFilter extends CatalogFilter {
  const WeaponFilter({
    this.name = '',
    this.series = '',
    this.kind,
    this.rarity,
    this.element,
  });

  final String name;
  final String series;
  final String? kind;
  final int? rarity;

  /// Id de [GameElement] (elemento o estado) que debe llevar el arma.
  final String? element;

  WeaponFilter copyWith({
    String? name,
    String? series,
    String? Function()? kind,
    int? Function()? rarity,
    String? Function()? element,
  }) =>
      WeaponFilter(
        name: name ?? this.name,
        series: series ?? this.series,
        kind: kind != null ? kind() : this.kind,
        rarity: rarity != null ? rarity() : this.rarity,
        element: element != null ? element() : this.element,
      );

  @override
  List<Object?> get props => [name, series, kind, rarity, element];
}

/// Ids de elemento y estado (`fire`, `poison`…) de los `specials` del arma.
/// Un arma lleva como mucho uno; el vial de las hachas no cuenta.
Set<String> weaponElementIds(Weapon weapon) {
  final specials = weapon.specials;
  if (specials is! List) return const {};
  return {
    for (final s in specials)
      if (s is Map && (s['kind'] == 'element' || s['kind'] == 'status'))
        if ((s['kind'] == 'element' ? s['element'] : s['status'])
            case final String id)
          GameElement.fromId(id)?.id ?? id.toLowerCase(),
  };
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
    final matchesElement = filter.element == null ||
        weaponElementIds(weapon).contains(filter.element);
    return matchesName &&
        matchesSeries &&
        matchesKind &&
        matchesRarity &&
        matchesElement;
  }).toList();
}
