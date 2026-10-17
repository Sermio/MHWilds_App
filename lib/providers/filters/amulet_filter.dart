import 'package:mhwilds_app/models/talisman.dart';
import 'package:mhwilds_app/providers/catalog_provider.dart';

class AmuletFilter extends CatalogFilter {
  const AmuletFilter({this.name = '', this.rarity});

  final String name;
  final int? rarity;

  AmuletFilter copyWith({String? name, int? Function()? rarity}) =>
      AmuletFilter(
        name: name ?? this.name,
        rarity: rarity != null ? rarity() : this.rarity,
      );

  @override
  List<Object?> get props => [name, rarity];
}

/// Talismanes (uno por rango) que cumplen [filter], de mayor a menor rareza
/// y luego por nombre.
List<Amulet> filterAmulets(List<Amulet> amulets, AmuletFilter filter) {
  final name = filter.name.toLowerCase();
  final result = amulets.where((amulet) {
    final rank = amulet.ranks.isNotEmpty ? amulet.ranks.first : null;
    if (rank == null) return false;
    final nameMatches = name.isEmpty || rank.name.toLowerCase().contains(name);
    final rarityMatches = filter.rarity == null || rank.rarity == filter.rarity;
    return nameMatches && rarityMatches;
  }).toList();

  result.sort((a, b) {
    final aRank = a.ranks.isNotEmpty ? a.ranks.first : null;
    final bRank = b.ranks.isNotEmpty ? b.ranks.first : null;
    final rarityComp = (bRank?.rarity ?? 0).compareTo(aRank?.rarity ?? 0);
    if (rarityComp != 0) return rarityComp;
    return (aRank?.name ?? '')
        .toLowerCase()
        .compareTo((bRank?.name ?? '').toLowerCase());
  });
  return result;
}
