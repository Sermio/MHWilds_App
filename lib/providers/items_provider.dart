import 'package:mhwilds_app/api/items_api.dart';
import 'package:mhwilds_app/models/item.dart';
import 'package:mhwilds_app/providers/catalog_provider.dart';
import 'package:mhwilds_app/providers/filters/item_filter.dart';
import 'package:mhwilds_app/utils/load_state.dart';

class ItemsProvider extends CatalogProvider<Item, ItemFilter> {
  ItemsProvider({super.api}) : super(const ItemFilter());

  List<Item> get items => visible;
  List<Item> get allItems => all;

  Future<void> fetchItems() => fetch();

  @override
  Stream<Data<List<Item>>> watch({required bool force}) =>
      ItemsApi.watchItems(force: force, lang: language, api: api);

  @override
  List<Item> prepare(List<Item> data) => data
    ..sort((a, b) {
      final rarityCompare = b.rarity.compareTo(a.rarity);
      if (rarityCompare != 0) return rarityCompare;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

  @override
  List<Item> applyFilter(List<Item> items, ItemFilter filter) =>
      filterItems(items, filter);
}
