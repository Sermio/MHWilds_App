import 'package:mhwilds_app/providers/filters/amulet_filter.dart';
import 'package:mhwilds_app/providers/talismans_provider.dart';

import 'cached_list_provider_contract.dart';

void main() {
  cachedListProviderContract<TalismansProvider>(
    'TalismansProvider',
    fixture: 'charms',
    create: (api) => TalismansProvider(api: api),
    total: (p) => p.filteredAmulets.length,
    filter: (p) => p.setFilter(
        AmuletFilter(name: p.filteredAmulets.first.ranks.first.name)),
    visible: (p) => p.filteredAmulets.length,
  );
}
