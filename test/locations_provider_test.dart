import 'package:mhwilds_app/providers/locations_provider.dart';

import 'cached_list_provider_contract.dart';

void main() {
  cachedListProviderContract<LocationsProvider>(
    'LocationsProvider',
    fixture: 'locations',
    create: (api) => LocationsProvider(api: api),
    total: (p) => p.zones.length,
  );
}
