import 'package:mhwilds_app/providers/decorations_provider.dart';

import 'cached_list_provider_contract.dart';
import 'package:mhwilds_app/providers/filters/decoration_filter.dart';

void main() {
  cachedListProviderContract<DecorationsProvider>(
    'DecorationsProvider',
    fixture: 'decorations',
    create: (api) => DecorationsProvider(api: api),
    total: (p) => p.decorations.length,
    filter: (p) =>
        p.setFilter(DecorationFilter(name: p.decorations.first.name)),
    visible: (p) => p.filteredDecorations.length,
  );
}
