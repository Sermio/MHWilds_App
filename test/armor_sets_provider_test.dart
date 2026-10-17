import 'package:mhwilds_app/providers/armor_sets_provider.dart';

import 'cached_list_provider_contract.dart';
import 'package:mhwilds_app/providers/filters/armor_set_filter.dart';

void main() {
  cachedListProviderContract<ArmorSetProvider>(
    'ArmorSetProvider',
    fixture: 'armor_sets',
    create: (api) => ArmorSetProvider(api: api),
    total: (p) => p.armorSets.length,
    filter: (p) => p.setFilter(ArmorSetFilter(name: p.armorSets.first.name)),
    visible: (p) => p.armorSets.length,
  );
}
