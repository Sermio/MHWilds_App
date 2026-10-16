import 'package:mhwilds_app/providers/talismans_provider.dart';

import 'cached_list_provider_contract.dart';

void main() {
  cachedListProviderContract<TalismansProvider>(
    'TalismansProvider',
    fixture: 'charms',
    create: (api) => TalismansProvider(api: api),
    total: (p) => p.filteredAmulets.length,
    filter: (p) =>
        p.applyFilters(name: p.filteredAmulets.first.ranks.first.name),
    visible: (p) => p.filteredAmulets.length,
  );
}
