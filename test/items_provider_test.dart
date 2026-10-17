import 'package:mhwilds_app/providers/items_provider.dart';

import 'cached_list_provider_contract.dart';
import 'package:mhwilds_app/providers/filters/item_filter.dart';

void main() {
  cachedListProviderContract<ItemsProvider>(
    'ItemsProvider',
    fixture: 'items',
    create: (api) => ItemsProvider(api: api),
    total: (p) => p.items.length,
    filter: (p) => p.setFilter(ItemFilter(name: p.items.first.name)),
    visible: (p) => p.items.length,
  );
}
