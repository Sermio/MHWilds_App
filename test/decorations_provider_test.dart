import 'package:mhwilds_app/providers/decorations_provider.dart';

import 'cached_list_provider_contract.dart';

void main() {
  cachedListProviderContract<DecorationsProvider>(
    'DecorationsProvider',
    fixture: 'decorations',
    create: (api) => DecorationsProvider(api: api),
    total: (p) => p.decorations.length,
    filter: (p) => p.applyFilters(name: p.decorations.first.name),
    visible: (p) => p.filteredDecorations.length,
  );
}
