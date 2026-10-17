import 'package:mhwilds_app/models/armor_set.dart';
import 'package:mhwilds_app/providers/catalog_provider.dart';

class ArmorSetFilter extends CatalogFilter {
  const ArmorSetFilter({this.name = '', this.kind, this.rarity});

  final String name;

  /// Tipo de pieza (`head`, `chest`…): deja solo esas piezas en cada set.
  final String? kind;
  final int? rarity;

  ArmorSetFilter copyWith({
    String? name,
    String? Function()? kind,
    int? Function()? rarity,
  }) =>
      ArmorSetFilter(
        name: name ?? this.name,
        kind: kind != null ? kind() : this.kind,
        rarity: rarity != null ? rarity() : this.rarity,
      );

  @override
  List<Object?> get props => [name, kind, rarity];
}

/// Sets cuyo nombre coincide y que conservan alguna pieza del tipo y rareza
/// pedidos; cada set devuelto trae solo esas piezas.
List<ArmorSet> filterArmorSets(List<ArmorSet> sets, ArmorSetFilter filter) {
  if (filter == const ArmorSetFilter()) return List.from(sets);
  final name = filter.name.toLowerCase();
  return [
    for (final set in sets)
      if (name.isEmpty || set.name.toLowerCase().contains(name))
        ...() {
          final pieces = set.pieces
              .where((piece) =>
                  (filter.kind == null || piece.kind == filter.kind) &&
                  (filter.rarity == null || piece.rarity == filter.rarity))
              .toList();
          if (pieces.isEmpty) return const <ArmorSet>[];
          return [
            ArmorSet(
              id: set.id,
              name: set.name,
              gameId: set.gameId,
              groupBonusSkill: set.groupBonusSkill,
              setBonusSkill: set.setBonusSkill,
              pieces: pieces,
            )
          ];
        }(),
  ];
}
