import 'package:mhwilds_app/models/item.dart';
import 'package:mhwilds_app/providers/catalog_provider.dart';

class ItemFilter extends CatalogFilter {
  const ItemFilter({this.name = '', this.rarity});

  final String name;
  final int? rarity;

  ItemFilter copyWith({String? name, int? Function()? rarity}) => ItemFilter(
        name: name ?? this.name,
        rarity: rarity != null ? rarity() : this.rarity,
      );

  @override
  List<Object?> get props => [name, rarity];
}

List<Item> filterItems(List<Item> items, ItemFilter filter) {
  final name = filter.name.toLowerCase();
  return items.where((item) {
    final matchesName = name.isEmpty || item.name.toLowerCase().contains(name);
    final matchesRarity = filter.rarity == null || item.rarity == filter.rarity;
    return matchesName && matchesRarity;
  }).toList();
}
