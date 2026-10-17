import 'package:mhwilds_app/models/armor_set.dart';
import 'package:mhwilds_app/providers/catalog_provider.dart';

class ArmorSetFilter extends CatalogFilter {
  const ArmorSetFilter({this.name = '', this.kind, this.rarity, this.element});

  final String name;

  /// Tipo de pieza (`head`, `chest`…): deja solo esas piezas en cada set.
  final String? kind;
  final int? rarity;

  /// Elemento (`fire`, `water`, `ice`, `thunder`, `dragon`): deja solo las
  /// piezas con resistencia mayor que 0 y ordena los sets por ella.
  final String? element;

  ArmorSetFilter copyWith({
    String? name,
    String? Function()? kind,
    int? Function()? rarity,
    String? Function()? element,
  }) =>
      ArmorSetFilter(
        name: name ?? this.name,
        kind: kind != null ? kind() : this.kind,
        rarity: rarity != null ? rarity() : this.rarity,
        element: element != null ? element() : this.element,
      );

  @override
  List<Object?> get props => [name, kind, rarity, element];
}

/// Sets cuyo nombre coincide y que conservan alguna pieza del tipo, la rareza
/// y la resistencia pedidos; cada set devuelto trae solo esas piezas.
///
/// Con [ArmorSetFilter.element] los sets salen de mayor a menor según su mejor
/// pieza para ese elemento (empates en el orden original). Dentro de cada set
/// las piezas conservan el orden cabeza → piernas.
List<ArmorSet> filterArmorSets(List<ArmorSet> sets, ArmorSetFilter filter) {
  if (filter == const ArmorSetFilter()) return List.from(sets);
  final name = filter.name.toLowerCase();
  final element = filter.element;
  final result = [
    for (final set in sets)
      if (name.isEmpty || set.name.toLowerCase().contains(name))
        ...() {
          final pieces = set.pieces
              .where((piece) =>
                  (filter.kind == null || piece.kind == filter.kind) &&
                  (filter.rarity == null || piece.rarity == filter.rarity) &&
                  (element == null || (piece.resistances[element] ?? 0) > 0))
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
  if (element == null) return result;

  int best(ArmorSet set) => set.pieces
      .map((p) => p.resistances[element] ?? 0)
      .reduce((a, b) => a > b ? a : b);
  // List.sort no es estable: el índice desempata para mantener el orden.
  final ranked = [
    for (var i = 0; i < result.length; i++) (index: i, best: best(result[i])),
  ]..sort((a, b) =>
      b.best != a.best ? b.best.compareTo(a.best) : a.index.compareTo(b.index));
  return [for (final r in ranked) result[r.index]];
}
